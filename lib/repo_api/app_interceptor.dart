import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../resources/strings.dart';
import '../utils/app_constants.dart';
import '../utils/app_utils.dart';
import '../utils/shared_preference_util.dart';
import 'network_exception.dart';

class AppInterceptor extends Interceptor {
  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    log("onRequest headers");
    // if (options.extra.containsKey('header')) {
    //   options.headers.addAll({
    //     'Authorization': await getToken(),
    //   });
    // }
    // if (options.extra.containsKey('language')) {
    //   var language = SharedPreferenceUtil.getString(appLanguage, defValue: strLocaleEn);
    //   // print(language);
    //   // print("language>>>>>>>>>>>>>>>>>");
    //
    //   options.headers.addAll({
    //     'Accept-Language': language.isNotEmpty ? language : strLocaleEn,
    //   });
    // }
    return handler.next(options);
  }

  // getToken() async {
  //   String? accessToken = "Bearer ${(await getLoginDataFromSP())?.data?.token}";
  //   if (kDebugMode) {
  //     print("Authorization $accessToken");
  //   }
  //   return accessToken;
  // }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.type == DioErrorType.sendTimeout || err.type == DioErrorType.connectTimeout || err.type == DioErrorType.receiveTimeout) {
      return ServerConnectionException('Couldn\'t connect with server. Please try again.');
    }

    if (err.type == DioErrorType.other && err.error is SocketException) {
      return handler.next(NoInternetException());
    }

    if (err.type == DioErrorType.response) {
      if (err.response?.statusMessage == 'Unauthorized' || err.response?.statusCode == 401) {
        // SharedPreferenceUtil.remove(isLoginKey);

        log("Unauthorized");
        showError(message: err.response?.statusMessage);

        ///  AppUtils.instance.pushAndClearStack(enterPage: LoginScreen());
        return null;
      }
      // if ((error.type == DioErrorType.DEFAULT) && (error.message == 'TokenExpired')) {
      // if (error.response!.data.message == 'UnAuthorized access.')
    }
    // if (error.type == DioErrorType.response) {
    //   if (error.response?.statusCode == 400) {
    //     //AppUtils.instance.logout('UnAuthorization access.');
    //     print("Unauthorized******************>>>>>>>>>>>>>>>>>>>");
    //     AppUtils.instance.popUp();
    //     return null;
    //   }
    //   // if ((error.type == DioErrorType.DEFAULT) && (error.message == 'TokenExpired')) {
    //   // if (error.response!.data.message == 'UnAuthorized access.')
    // }

    if ((err.type == DioErrorType.other) && (err.message == 'TokenExpired' || err.message == 'Authorization error')) {
      // if ((error.type == DioErrorType.DEFAULT) && (error.message == 'TokenExpired')) {
      // AppUtils.instance.logout(error.message);
      return null;
    }

    // Check if server responded with non-success status code.
    // In this case, we will check if we got a specific error
    // from API to display to the user.
    if (err.type == DioErrorType.response && err.response != null) {
      NetworkException networkException =
          _getErrorObject(err.response!, err.requestOptions) ?? NetworkException(err.requestOptions, strSomethingWentWrongPleaseTryAgain);
      return handler.next(networkException);
    }

    return handler.next(err);
  }

  /// Parses the response to get the error object if any
  /// from the API response based on status code.
  NetworkException? _getErrorObject(Response response, RequestOptions requestOptions) {
    final responseData = response.data;
    // if (response.statusCode == 403) SessionExpiryNotifier.notifySessionExpiry();
    // if (response.statusCode == 403)
    //   AppUtils.instance.logout(responseData?.toString() ?? '');

    if (responseData != null && responseData is Map) {
      if (responseData.containsKey('status')) {
        // final status = responseData['status'];
        // if (!status) {
        // final errorsMap = responseData['errors'];
        /*if (errorsMap != null && errorsMap is Map) {
            Map<String, dynamic> map = errorsMap as Map<String, dynamic>;
            if (map.isNotEmpty) {
              final key = map.keys.toList()[0];
              return NetworkException(
                requestOptions,
                map[key] ?? 'Something went wrong, please try again!',
                code: response.statusCode ?? 0,
              );
            }
          }*/
        return NetworkException(
          requestOptions,
          responseData['message'] ?? strSomethingWentWrongPleaseTryAgain,
          code: response.statusCode ?? 0,
        );
        // }
      }
    }

    return throw FetchDataException('Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }

/*@override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    response.data = _response(response);
    return super.onResponse(response, handler);
  }*/

/*dynamic _response(Response<dynamic> response) {
    var responseJson = Map<String, dynamic>.from(response.data);
    String message = responseJson["message"];

    if (responseJson["status"] ?? false) {
      return responseJson;
    }

    if (responseJson["error"] == false) {
      return responseJson;
    }

    if (responseJson["error"] == true) {
      if (responseJson["status"] == 500) {
        if ((responseJson['info'] != null) &&
            (responseJson["info"]['error'] != null)) {
          message = responseJson["info"]['error'];
        }
      }
    }

    throw ErrorResponseException(null, message);
  }

  void _logOutDevice(Response? response) {
    if (response!.statusCode == 401) {
      print("Its logout process");

    }
  }*/
}

// import 'dart:io';
//
// import 'package:dio/dio.dart';
//
// import '../utils/app_utils.dart';
// import '../utils/shared_preference_util.dart';

// class AppInterceptor extends Interceptor {
//   @override
//   Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
//     _addCommonHeaders(options);
//     return handler.next(options);
//   }
//
//   void _addCommonHeaders(RequestOptions options) {
//     if (options.extra.containsKey('header')) options.headers['Authorization'] = _getAuthorizationToken();
//     // if (options.extra.containsKey('language')) options.headers['Accept-Language'] = SharedPreferenceUtil.getString(appLanguage);
//     if (options.extra.containsKey('language')) options.headers['Accept-Language'] = "en";
//   }
//
//   Future<String> _getAuthorizationToken() async {
//     print("Bearer ${(await getLoginDataFromSP())?.data?.token.toString() ?? ""}");
//     return "Bearer ${(await getLoginDataFromSP())?.data?.token.toString() ?? ""}";
//     return "Bearer ";
//   }
//
//   @override
//   Future onError(DioException err, ErrorInterceptorHandler handler) async {
//     if (_shouldHandleError(err)) _handleError();
//     return handler.next(err);
//   }
//
//   bool _shouldHandleError(DioException error) {
//     return (/*error.type == DioExceptionType.sendTimeout ||
//         error.type == DioExceptionType.connectionTimeout ||
//         error.type == DioExceptionType.receiveTimeout ||*/
//         (error.type == DioExceptionType.unknown && error.error is SocketException) ||
//             (error.type == DioExceptionType.badResponse && (error.response?.statusMessage == 'Unauthorized' && error.response?.statusCode == 401)) ||
//             (error.type == DioExceptionType.badResponse && (error.message == 'TokenExpired' || error.message == 'Authorization error')));
//   }
//
//   void _handleError() {
//     AppUtils.instance.logout();
//   }
// }
