import 'package:dio/dio.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

import '../models/api_response_model.dart';

class ApiService {
  // Dio instance for making HTTP requests
  final Dio _dio = Dio();

  ApiService() {
    // Add a logger interceptor to Dio for debugging HTTP requests and responses
    _dio.interceptors.add(TalkerDioLogger());
  }

  /// Fetch data from the API
  ///
  /// [url] - The API endpoint URL.
  /// [query] - The search query parameter.
  /// [page] - The page number for pagination.
  ///
  /// Returns an [ApiResponse] object.
  Future<ApiResponse> fetchData({required String url, required String query, required int page}) async {
    try {
      // Perform the GET request with query parameters
      final response = await _dio.get(
          url,
          queryParameters: {'terms': query, 'format': 'json', 'page': page}
      );

      if (response.statusCode == 200) {
        // Parse and return the response data if the status code is 200
        return ApiResponse.fromJson(response.data);
      } else {
        // Handle non-200 HTTP status codes
        _handleApiError(response.statusCode, response.data);
      }
    } on DioException catch (e) {
      // Handle network or Dio-related errors
      throw _handleDioError(e);
    } catch (e) {
      // Handle unexpected errors
      throw Exception('Unexpected error: $e');
    }

    // Ensure that all code paths return or throw
    throw Exception('Unexpected response');
  }

  /// Handle API errors based on the HTTP status code
  ///
  /// [statusCode] - The HTTP status code from the response.
  /// [data] - The response data containing error details.
  ///
  /// Throws an [Exception] with a descriptive error message.
  ApiResponse _handleApiError(int? statusCode, dynamic data) {
    String message;
    switch (statusCode) {
      case 400:
        message = 'Bad Request: ${data['message'] ?? 'Invalid request'}';
        break;
      case 401:
        message = 'Unauthorized: ${data['message'] ?? 'Authentication required'}';
        break;
      case 403:
        message = 'Forbidden: ${data['message'] ?? 'Access denied'}';
        break;
      case 404:
        message = 'Not Found: ${data['message'] ?? 'Resource not found'}';
        break;
      case 500:
        message = 'Server Error: ${data['message'] ?? 'Internal server error'}';
        break;
      default:
        message = 'Unexpected status code: $statusCode';
        break;
    }
    throw Exception(message);
  }

  /// Handle Dio network-related errors
  ///
  /// [e] - The DioException object containing error details.
  ///
  /// Returns an [Exception] with a descriptive error message.
  Exception _handleDioError(DioException e) {
    String message;
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Connection timeout. Please check your network connection.';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Request send timeout. Please try again later.';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Response receive timeout. Please try again later.';
        break;
      case DioExceptionType.badResponse:
        message = 'Received invalid status code: ${e.response?.statusCode}';
        break;
      case DioExceptionType.cancel:
        message = 'Request was cancelled. Please try again.';
        break;
      case DioExceptionType.unknown:
        message = 'An unexpected error occurred: ${e.message}';
        break;
      case DioExceptionType.badCertificate:
        message = 'Invalid SSL certificate. Please check your network connection.';
        break;
      case DioExceptionType.connectionError:
        message = 'A network error occurred. Please check your network connection.';
        break;
    }
    return Exception(message);
  }
}
