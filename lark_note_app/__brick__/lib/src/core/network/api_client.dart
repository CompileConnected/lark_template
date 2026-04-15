{{#network_http}}import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client _client;
  final String baseUrl;

  ApiClient({required this.baseUrl, http.Client? client})
      : _client = client ?? http.Client();

  Future<http.Response> get(String path, {Map<String, String>? headers}) {
    return _client.get(
      Uri.parse('$baseUrl$path'),
      headers: {...?headers},
    );
  }

  Future<http.Response> post(
    String path, {
    Map<String, String>? headers,
    Object? body,
  }) {
    return _client.post(
      Uri.parse('$baseUrl$path'),
      headers: {'Content-Type': 'application/json', ...?headers},
      body: body,
    );
  }

  Future<http.Response> put(
    String path, {
    Map<String, String>? headers,
    Object? body,
  }) {
    return _client.put(
      Uri.parse('$baseUrl$path'),
      headers: {'Content-Type': 'application/json', ...?headers},
      body: body,
    );
  }

  Future<http.Response> delete(
    String path, {
    Map<String, String>? headers,
  }) {
    return _client.delete(
      Uri.parse('$baseUrl$path'),
      headers: {...?headers},
    );
  }
}{{/network_http}}{{#network_dio}}import 'package:dio/dio.dart';
{{#attach_logger_to_http_dio}}import 'package:dio_logger_plus/dio_logger_plus.dart';{{/attach_logger_to_http_dio}}

class ApiClient {
  final Dio _dio;

  ApiClient({required String baseUrl, Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: baseUrl)) {
    {{#attach_logger_to_http_dio}}_dio.interceptors.add(DioLoggerPlus());{{/attach_logger_to_http_dio}}
  }

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.get<T>(path, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Options? options,
  }) {
    return _dio.post<T>(path, data: data, options: options);
  }

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Options? options,
  }) {
    return _dio.put<T>(path, data: data, options: options);
  }

  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Options? options,
  }) {
    return _dio.delete<T>(path, data: data, options: options);
  }
}{{/network_dio}}{{#network_rhttp}}import 'package:rhttp/rhttp.dart';

class ApiClient {
  final Client _client;
  final String baseUrl;

  ApiClient({required this.baseUrl}) : _client = Client();

  Future<HttpResponse> get(String path, {Map<String, String>? headers}) {
    return _client.get(
      '$baseUrl$path',
      headers: HttpHeaders.fromMap(headers ?? {}),
    );
  }

  Future<HttpResponse> post(String path, {String? body, Map<String, String>? headers}) {
    return _client.post(
      '$baseUrl$path',
      headers: HttpHeaders.fromMap(headers ?? {}),
      body: HttpBody.text(body ?? ''),
    );
  }

  Future<HttpResponse> put(String path, {String? body, Map<String, String>? headers}) {
    return _client.put(
      '$baseUrl$path',
      headers: HttpHeaders.fromMap(headers ?? {}),
      body: HttpBody.text(body ?? ''),
    );
  }

  Future<HttpResponse> delete(String path, {Map<String, String>? headers}) {
    return _client.delete(
      '$baseUrl$path',
      headers: HttpHeaders.fromMap(headers ?? {}),
    );
  }
}{{/network_rhttp}}
