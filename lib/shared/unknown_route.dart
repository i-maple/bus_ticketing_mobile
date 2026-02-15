import 'package:flutter/material.dart';

/// Simple page to display when an unknown route is accessed.
class UnknownRoutePage extends StatelessWidget {
  const UnknownRoutePage({super.key, this.routeName});

  /// The name of the route that was attempted to be accessed.
  final String? routeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Not Found')),
      body: Center(
        child: Text('No route defined for: ${routeName ?? 'unknown'}'),
      ),
    );
  }
}
