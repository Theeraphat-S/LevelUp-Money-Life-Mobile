import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  late final Dio dio;
  final String baseUrl;

  ApiClient({String? baseUrl, Dio? customDio})
      : baseUrl = baseUrl ??
            dotenv.env['API_BASE_URL'] ??
            'https://api.levelup-moneylife.com/api/v1' {
    dio = customDio ??
        Dio(
          BaseOptions(
            baseUrl: this.baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add Auth Bearer token if present
          final token = dotenv.env['AUTH_TOKEN'];
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          // Log or customize error
          return handler.next(e);
        },
      ),
    );
  }
}
