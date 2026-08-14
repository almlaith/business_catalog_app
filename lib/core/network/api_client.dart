import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:business_catalog_app/features/catalog/data/catalog_repository.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient({
    required this.baseUrl,
    http.Client? httpClient,
    this.timeout = const Duration(seconds: 12),
  }) : _httpClient = httpClient ?? http.Client();

  final Uri baseUrl;
  final Duration timeout;
  final http.Client _httpClient;

  Future<Map<String, Object?>> getJsonObject(String path) async {
    try {
      final response = await _httpClient
          .get(
            baseUrl.resolve(path),
            headers: const {'Accept': 'application/json'},
          )
          .timeout(timeout);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        if (response.statusCode >= 500) {
          throw const CatalogRepositoryException.server();
        }
        throw const CatalogRepositoryException.invalidResponse();
      }

      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is! Map<String, Object?>) {
        throw const CatalogRepositoryException.invalidResponse();
      }
      return decoded;
    } on CatalogRepositoryException {
      rethrow;
    } on TimeoutException {
      throw const CatalogRepositoryException.timeout();
    } on SocketException {
      throw const CatalogRepositoryException.network();
    } on http.ClientException {
      throw const CatalogRepositoryException.network();
    } on FormatException {
      throw const CatalogRepositoryException.invalidResponse();
    } catch (_) {
      throw const CatalogRepositoryException.invalidResponse();
    }
  }
}
