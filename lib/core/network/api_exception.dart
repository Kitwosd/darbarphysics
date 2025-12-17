import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String errorMessage;
  final int? statusCode;

  ApiException({required this.errorMessage, this.statusCode});

  @override
  String toString() => errorMessage;
}

ApiException handleDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
      return ApiException(errorMessage: 'Connection timed out');

    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode;
      final message = e.response?.data?['message'] ?? 'Unknown error';

      return ApiException(errorMessage: message, statusCode: statusCode);

    case DioExceptionType.connectionError:
      return ApiException(errorMessage: 'No internet Connection');

    default:
      return ApiException(errorMessage: 'Something went wrong');
  }
}
