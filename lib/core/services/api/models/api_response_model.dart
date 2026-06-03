// /// api_response_model.dart
//
// class ApiResponseModel<T> {
//   final String? message;
//   final T? data;
//   final bool isSuccess;
//   final int? statusCode;
//
//   const ApiResponseModel({
//     this.message,
//     this.data,
//     this.isSuccess = true,
//     this.statusCode,
//   });
//
//   /// Use this in every repository/service to parse the ApiResponse
//   /// [fromJson] converts the raw Map into your specific model T
//   factory ApiResponseModel.fromApiResponse({
//     required Map<String, dynamic>? rawData,
//     required String? message,
//     required int statusCode,
//     T Function(Map<String, dynamic>)? fromJson,
//   }) {
//     T? parsedData;
//
//     if (fromJson != null && rawData != null && rawData.isNotEmpty) {
//       try {
//         parsedData = fromJson(rawData);
//       } catch (e) {
//         parsedData = null;
//       }
//     }
//
//     return ApiResponseModel<T>(
//       message: message,
//       data: parsedData,
//       isSuccess: true,
//       statusCode: statusCode,
//     );
//   }
//
//   @override
//   String toString() =>
//       'ApiResponseModel(statusCode: $statusCode, isSuccess: $isSuccess, '
//           'message: $message, data: $data)';
// }