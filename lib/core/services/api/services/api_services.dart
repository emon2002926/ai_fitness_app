import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../util/app_log.dart';
import '../../../widgets/snakbar/custom_snackbar.dart';


class ApiServices {
  final String baseUrl;
  final http.Client _httpClient;

  ApiServices({required this.baseUrl, http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final Map<String, String> _defaultHeader = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  List<String> _mimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg': return ['image', 'jpeg'];
      case 'png':  return ['image', 'png'];
      case 'webp': return ['image', 'webp'];
      case 'gif':  return ['image', 'gif'];
      case 'mp4':  return ['video', 'mp4'];
      case 'mpeg': return ['video', 'mpeg'];
      case 'mov':  return ['video', 'quicktime'];
      case 'webm': return ['video', 'webm'];
      default:     return ['application', 'octet-stream'];
    }
  }

  Future<ApiResponse> get(String endpoints, {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl$endpoints');
    AppLog.request(endpoints, method: 'GET');
    return _execute(
      endpoints: endpoints,
      request: () => _httpClient.get(url, headers: {..._defaultHeader, ...?headers}),
    );
  }

  Future<ApiResponse> post(String endpoints, {Map<String, String>? headers, dynamic body}) async {
    final url = Uri.parse('$baseUrl$endpoints');
    AppLog.request(endpoints, method: 'POST', body: body);
    return _execute(
      endpoints: endpoints,
      request: () => _httpClient.post(
        url,
        headers: {..._defaultHeader, ...?headers},
        body: body != null ? jsonEncode(body) : null,
      ),
    );
  }

  Future<ApiResponse> delete(String endpoints, {Map<String, String>? headers, dynamic body}) async {
    final url = Uri.parse('$baseUrl$endpoints');
    AppLog.request(endpoints, method: 'DELETE', body: body);
    return _execute(
      endpoints: endpoints,
      request: () => _httpClient.delete(
        url,
        headers: {..._defaultHeader, ...?headers},
        body: body != null ? jsonEncode(body) : null,
      ),
    );
  }

  Future<ApiResponse> patch(String endpoints, {Map<String, String>? headers, dynamic body}) async {
    final url = Uri.parse('$baseUrl$endpoints');
    AppLog.request(endpoints, method: 'PATCH', body: body);
    return _execute(
      endpoints: endpoints,
      request: () => _httpClient.patch(
        url,
        headers: {..._defaultHeader, ...?headers},
        body: body != null ? jsonEncode(body) : null,
      ),
    );
  }

  Future<ApiResponse> put(String endpoints, {Map<String, String>? headers, dynamic body}) async {
    final url = Uri.parse('$baseUrl$endpoints');
    AppLog.request(endpoints, method: 'PUT', body: body);
    return _execute(
      endpoints: endpoints,
      request: () => _httpClient.put(
        url,
        headers: {..._defaultHeader, ...?headers},
        body: body != null ? jsonEncode(body) : null,
      ),
    );
  }

  Future<ApiResponse> postFormData(
      String endpoints, {
        Map<String, String>? headers,
        required Map<String, String> fields,
        File? imageFile,
        String imageFieldName = "image",
      }) async {
    final url = Uri.parse('$baseUrl$endpoints');
    AppLog.request(endpoints, method: 'POST [form-data]', body: fields);
    return _execute(
      endpoints: endpoints,
      request: () async {
        final request = http.MultipartRequest('POST', url);
        request.headers.addAll({'Accept': 'application/json', ...?headers});
        request.fields.addAll(fields);
        if (imageFile != null) {
          final ext = imageFile.path.split('.').last;
          final mime = _mimeType(ext);
          request.files.add(await http.MultipartFile.fromPath(
            imageFieldName,
            imageFile.path,
            contentType: http.MediaType(mime[0], mime[1]),
          ));
        }
        final streamed = await _httpClient.send(request);
        return http.Response.fromStream(streamed);
      },
    );
  }

  Future<ApiResponse> putFormData(
      String endpoints, {
        Map<String, String>? headers,
        required Map<String, String> fields,
        File? imageFile,
        String imageFieldName = "image",
      }) async {
    final url = Uri.parse('$baseUrl$endpoints');
    AppLog.request(endpoints, method: 'PUT [form-data]', body: fields);
    return _execute(
      endpoints: endpoints,
      request: () async {
        final request = http.MultipartRequest('PUT', url);
        request.headers.addAll({'Accept': 'application/json', ...?headers});
        request.fields.addAll(fields);
        if (imageFile != null) {
          final ext = imageFile.path.split('.').last;
          final mime = _mimeType(ext);
          request.files.add(await http.MultipartFile.fromPath(
            imageFieldName,
            imageFile.path,
            contentType: http.MediaType(mime[0], mime[1]),
          ));
        }
        final streamed = await _httpClient.send(request);
        return http.Response.fromStream(streamed);
      },
    );
  }



  Future<ApiResponse> patchFormData(
      String endpoints, {
        Map<String, String>? headers,
        required Map<String, String> fields,
        File? imageFile,
        String imageFieldName = "image",
      }) async {
    final url = Uri.parse('$baseUrl$endpoints');
    AppLog.request(endpoints, method: 'PATCH [form-data]', body: fields);
    return _execute(
      endpoints: endpoints,
      request: () async {
        final request = http.MultipartRequest('PATCH', url);
        request.headers.addAll({'Accept': 'application/json', ...?headers});
        request.fields.addAll(fields);
        if (imageFile != null) {
          final ext  = imageFile.path.split('.').last;
          final mime = _mimeType(ext);
          request.files.add(await http.MultipartFile.fromPath(
            imageFieldName,
            imageFile.path,
            contentType: http.MediaType(mime[0], mime[1]),
          ));
        }
        final streamed = await _httpClient.send(request);
        return http.Response.fromStream(streamed);
      },
    );
  }





  Future<ApiResponse> _execute({
    required String endpoints,
    required Future<http.Response> Function() request,
  }) async {
    try {
      final response = await request();
      return _handleResponse(response, Uri.parse('$baseUrl$endpoints'), endpoints);
    } on SocketException {
      AppLog.error(endpoints, 'No internet connection');
      CustomSnackBar.error('No internet connection. Please check your network.');
      rethrow;
    } on http.ClientException catch (e) {
      AppLog.error(endpoints, e.message);
      CustomSnackBar.error('Network error. Please try again.');
      rethrow;
    } on TimeoutException {
      AppLog.error(endpoints, 'Request timed out');
      CustomSnackBar.error('Request timed out. Please try again.');
      rethrow;
    }
  }

  ApiResponse _handleResponse(http.Response response, Uri url, String endpoint) {
    final bool isSuccess = response.statusCode >= 200 && response.statusCode < 300;

    Map<String, dynamic>? decoded;
    if (response.body.isNotEmpty) {
      try {
        decoded = jsonDecode(response.body) as Map<String, dynamic>?;
      } catch (_) {
        decoded = null;
      }
    }

    // Extract message: prefer 'message', fallback to 'detail'
    final String? message = decoded != null
        ? (decoded['message'] ?? decoded['detail'])?.toString()
        : null;

    if (isSuccess) {
      AppLog.response(endpoint, decoded);

      // Strip 'message' key — everything else is the payload data
      final Map<String, dynamic> data = Map.from(decoded ?? {})..remove('message');

      return ApiResponse(
        statusCode: response.statusCode,
        message: message,
        data: data.isEmpty ? null : data,
        isSuccess: true,
      );
    }

    // --- Error path ---
    final String errorMessage = message ?? 'Something went wrong. Please try again.';
    AppLog.error(endpoint, response.body, statusCode: response.statusCode);
    CustomSnackBar.error(errorMessage);

    throw HttpException(
      message: errorMessage,
      statusCode: response.statusCode,
      uri: url,
      body: response.body,
    );
  }
}


/// Wrapper returned by every ApiServices method on success.
class ApiResponse {
  /// HTTP status code (2xx on success).
  final int statusCode;

  /// The 'message' (or 'detail') field from the server, if present.
  final String? message;

  /// Everything in the response body except the 'message' key.
  /// e.g. { "user_details": {...}, "access": "...", "refresh": "..." }
  final Map<String, dynamic>? data;

  final bool isSuccess;

  const ApiResponse({
    required this.statusCode,
    required this.isSuccess,
    this.message,
    this.data,
  });

  /// Convenience: pull a top-level key out of [data].
  /// e.g. response.get<Map>('user_details')
  T? get<T>(String key) => data?[key] as T?;

  @override
  String toString() =>
      'ApiResponse(statusCode: $statusCode, isSuccess: $isSuccess, '
          'message: $message, data: $data)';
}


class HttpException implements Exception {
  final String message;
  final int statusCode;
  final Uri uri;
  final String? body;
  final String? status; // ✅ e.g. "resend_activation"


  HttpException({
    required this.message,
    required this.statusCode,
    required this.uri,
    this.body,
    this.status,

  });

  @override
  String toString() =>
      'HttpException(statusCode: $statusCode, uri: $uri, message: $message, body: $body)';
}