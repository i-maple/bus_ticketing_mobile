import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../../config/app_config.dart';
import '../../../../../core/error/exceptions.dart';
import '../../models/khalti_initiate_result_model.dart';
import '../../models/khalti_lookup_result_model.dart';
import '../../../domain/entities/khalti_initiate_params.dart';

abstract class KhaltiRemoteDataSource {
  Future<KhaltiInitiateResultModel> initiatePayment(KhaltiInitiateParams params);

  Future<KhaltiLookupResultModel> lookupPayment(String pidx);
}

class KhaltiRemoteDataSourceImpl implements KhaltiRemoteDataSource {
  KhaltiRemoteDataSourceImpl(this._client);

  final http.Client _client;
  static const Duration _requestTimeout = Duration(seconds: 15);

  @override
  Future<KhaltiInitiateResultModel> initiatePayment(
    KhaltiInitiateParams params,
  ) async {
    final response = await _postJson(
      path: '/epayment/initiate/',
      body: params.toJson(),
    );

    debugPrint('Resbody: ${response.body}');
    debugPrint('Params: ${params.toJson()}');
    final payload = _parseBody(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ServerException(_extractErrorMessage(payload), code: '${response.statusCode}');
    }

    return KhaltiInitiateResultModel.fromJson(payload);
  }

  @override
  Future<KhaltiLookupResultModel> lookupPayment(String pidx) async {
    final response = await _postJson(
      path: '/epayment/lookup/',
      body: {'pidx': pidx},
    );

    final payload = _parseBody(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ServerException(_extractErrorMessage(payload), code: '${response.statusCode}');
    }

    return KhaltiLookupResultModel.fromJson(payload);
  }

  Future<http.Response> _postJson({
    required String path,
    required Map<String, dynamic> body,
  }) async {
    try {
      return await _client
          .post(
            Uri.parse('${_baseUrl()}$path'),
            headers: _headers(),
            body: jsonEncode(body),
          )
          .timeout(_requestTimeout);
    } on TimeoutException {
      throw const NetworkException('Khalti request timed out');
    } on SocketException {
      throw const NetworkException('Network unavailable while contacting Khalti');
    } on http.ClientException catch (error) {
      throw NetworkException(error.message);
    }
  }

  String _baseUrl() {
    final base = AppConfig.khaltiBaseUrl.trim();
    if (base.isEmpty) {
      throw const ServerException('KHALTI_BASE_URL is not configured');
    }

    return base.endsWith('/') ? base.substring(0, base.length - 1) : base;
  }

  Map<String, String> _headers() {
    final key = AppConfig.khaltiSecretKey.trim();
    if (key.isEmpty) {
      throw const ServerException('KHALTI_SECRET_KEY is not configured');
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Key $key',
    };
  }

  Map<String, dynamic> _parseBody(String body) {
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    throw const ParsingException('Invalid response payload from Khalti');
  }

  String _extractErrorMessage(Map<String, dynamic> payload) {
    final detail = payload['detail']?.toString();
    if (detail != null && detail.isNotEmpty) {
      return detail;
    }

    final amountErrors = payload['amount'];
    if (amountErrors is List && amountErrors.isNotEmpty) {
      return amountErrors.first.toString();
    }

    final returnUrlErrors = payload['return_url'];
    if (returnUrlErrors is List && returnUrlErrors.isNotEmpty) {
      return returnUrlErrors.first.toString();
    }

    return 'Khalti payment request failed';
  }
}
