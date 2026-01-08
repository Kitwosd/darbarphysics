  import 'package:dio/dio.dart';

  class ApiException implements Exception {
    final String errorMessage;
    final int? statusCode;
    final dynamic response; // Added to hold full response data

    ApiException({required this.errorMessage, this.statusCode, this.response});

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
        // Extract message if possible, but keep full data for individual field errors
        final dynamic data = e.response?.data;
        final message = data is Map && data.containsKey('message')
            ? data['message']
            : 'Server error $statusCode';

        return ApiException(
          errorMessage: message.toString(),
          statusCode: statusCode,
          response: data,
        );

      case DioExceptionType.connectionError:
        return ApiException(errorMessage: 'No internet Connection');

      default:
        return ApiException(errorMessage: 'Something went wrong');
    }
  }
