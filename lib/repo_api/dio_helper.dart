import 'package:dio/dio.dart';

import '../repo_api/rest_constants.dart';
import 'app_interceptor.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: RestConstants.baseUrl,
        receiveDataWhenStatusError: true,
      ),
    );

    dio.interceptors.addAll([
      LogInterceptor(
        error: true,
        requestHeader: true,
        requestBody: true,
        responseBody: true,
      ),
      AppInterceptor(),
    ]);
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    bool isHeader = false,
    bool isLanguage = false,
  }) async {
    return await dio.get(
      url,
      queryParameters: query,
      options: Options(
        extra: {
          'header': isHeader,
          'language': isLanguage,
        },
      ),
    );
  }

  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? query,
    bool isHeader = false,
  }) async {
    return await dio.delete(
      url,
      queryParameters: query,
      options: Options(
        extra: {
          'header': isHeader,
        },
      ),
    );
  }

  static Future<Response> postData({
    required String url,
    Map<dynamic, dynamic>? data,
    FormData? formData,
    bool isHeader = false,
    bool isAllow412 = false,
    bool isLanguage = false,
    double? latitude,
    double? longitude,
  }) async {
    return await dio.post(
      url,
      data: formData ?? data,
      options: Options(
        extra: {
          'header': isHeader,
          'language': isLanguage,
        },
        validateStatus: (status) {
          return isAllow412 && status == 412
              ? true
              : status == 200
                  ? true
                  : false;
        },
        headers: {
          /// Include additional headers
          if (latitude != null) 'x-latitude': latitude.toString(),
          if (longitude != null) 'x-longitude': longitude.toString(),
        },
      ),
    );
  }

  static Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    dio.options.headers = {
      'Accept-Language': lang,
      'Authorization': token ?? '',
      'Content-Type': 'application/json',
    };
    return await dio.put(
      url,
      queryParameters: query,
      data: data,
    );
  }
}
// class DioHelper {
//   static final Dio dio = Dio(BaseOptions(baseUrl: RestConstants.baseUrl, connectTimeout: const Duration(seconds: 10), receiveDataWhenStatusError: true));
//
//   static init() {
//     dio.interceptors.addAll([PrettyDioLogger(requestHeader: true, requestBody: true, responseBody: true, responseHeader: false, error: true, compact: true, maxWidth: 100), AppInterceptor()]);
//   }
//
//   static Future<Response> getData({required String url, Map<String, dynamic>? query, bool isHeader = false}) => dio.get(url, queryParameters: query, options: _requestOptions(isHeader: isHeader));
//
//   static Future<Response> postData({required String url, Map<dynamic, dynamic>? data, FormData? formData, bool isHeader = false, bool isLanguage = true, bool isAllow412 = false}) =>
//       dio.post(url, data: formData ?? data, options: _requestOptions(isHeader: isHeader, isLanguage: isLanguage, isAllow412: isAllow412));
//
//   static Future<Response> putData({required String url, required Map<String, dynamic> data, Map<String, dynamic>? query, String lang = strLocaleEn, String? token}) {
//     lang = SharedPreferenceUtil.getString(appLanguage);
//     final headers = {'Accept-Language': lang, 'Authorization': token ?? '', 'Content-Type': 'application/json'};
//     dio.options.headers = headers;
//     return dio.put(url, queryParameters: query, data: data);
//   }
//
//   static Options _requestOptions({bool isHeader = false, bool isLanguage = false, bool isAllow412 = false}) {
//     final extraOptions = {if (isHeader) 'header': isHeader, if (isLanguage) 'language': true};
//
//     return Options(
//         extra: extraOptions,
//         validateStatus: (status) {
//           return isAllow412 && status == 412
//               ? true
//               : status == 200
//                   ? true
//                   : false;
//         });
//   }
// }
