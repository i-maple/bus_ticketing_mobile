import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:app_links/app_links.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/khalti_checkout_args.dart';
import '../providers/payment_provider.dart';

class KhaltiCheckoutPage extends ConsumerStatefulWidget {
  const KhaltiCheckoutPage({super.key, required this.args});

  final KhaltiCheckoutArgs args;

  @override
  ConsumerState<KhaltiCheckoutPage> createState() => _KhaltiCheckoutPageState();
}

class _KhaltiCheckoutPageState extends ConsumerState<KhaltiCheckoutPage> {
  final AppLinks _appLinks = AppLinks();
  late final WebViewController _controller;
  StreamSubscription<Uri?>? _deepLinkSubscription;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (request) {
                final uri = Uri.tryParse(request.url);
                final checkoutHandler = ref.read(khaltiCheckoutHandlerProvider);
                if (uri != null && checkoutHandler.isReturnUrl(uri)) {
                  _handleCallback(uri);
                  return NavigationDecision.prevent;
                }

                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.args.paymentUrl));

    _listenForDeepLinks();
  }

  Future<void> _listenForDeepLinks() async {
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleIncomingDeepLink(initialUri);
      }
    } on PlatformException catch (error) {
      debugPrint('Deep link platform error: $error');
    } on FormatException catch (error) {
      debugPrint('Invalid deep link format: $error');
    }

    _deepLinkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleIncomingDeepLink(uri);
    });
  }

  void _handleIncomingDeepLink(Uri uri) {
    final checkoutHandler = ref.read(khaltiCheckoutHandlerProvider);
    if (checkoutHandler.isReturnUrl(uri)) {
      _handleCallback(uri);
    }
  }

  Future<void> _handleCallback(Uri uri) async {
    if (_isVerifying) return;
    setState(() => _isVerifying = true);

    final checkoutHandler = ref.read(khaltiCheckoutHandlerProvider);
    final result = await checkoutHandler.verifyCallback(
      args: widget.args,
      callbackUri: uri,
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() => _isVerifying = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      },
      (status) {
        context.pop(status);
      },
    );
  }

  Future<void> _cancelAndClose() async {
    final result = await ref
        .read(khaltiCheckoutHandlerProvider)
        .cancelCheckout(widget.args);

    if (!mounted) return;
    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      },
      (status) {
        context.pop(status);
      },
    );
  }

  @override
  void dispose() {
    _deepLinkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khalti Checkout'),
        actions: [
          IconButton(
            onPressed: _cancelAndClose,
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isVerifying)
            const ColoredBox(
              color: Colors.black26,
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
