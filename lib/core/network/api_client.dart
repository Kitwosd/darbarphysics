import 'package:dio/dio.dart';
import 'package:durbar_physics/core/network/api_exception.dart';

enum ApiMethod { get, post, put, patch, delete }

class ApiClient {
  ApiClient._instanceCreator(); //instance created of ApiClient
  static final ApiClient _singeInstance =
      ApiClient._instanceCreator(); // the instace is stored in the variable
  factory ApiClient() =>
      _singeInstance; // now we can access that single instance only with factory constructor

  late Dio _dio;

  void init({required String baseUrl, String? accessToken}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (accessToken != null) 'Authorization': 'Bearer $accessToken',
        },
      ),
    );
  }

  void updateAccessToken(String accessToken) {
    _dio.options.headers['Authorization'] = 'Bearer $accessToken';
  }

  void clearAccessToken() {
    _dio.options.headers.remove('Authorization');
  }

  Future<dynamic> request({
    required String path,
    required ApiMethod method,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      Response response;
      switch (method) {
        case ApiMethod.get:
          response = await _dio.get(
            path,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
          );
          break;
        case ApiMethod.post:
          response = await _dio.post(
            path,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
            data: data,
          );
          break;
        case ApiMethod.put:
          response = await _dio.put(
            path,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
            data: data,
          );
          break;
        case ApiMethod.delete:
          response = await _dio.delete(
            path,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
            data: data,
          );
          break;
        case ApiMethod.patch:
          response = await _dio.patch(
            path,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
            data: data,
          );
          break;
      }
      return response.data;
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      throw ApiException(errorMessage: 'Unexpected error: $e');
    }
  }
}
