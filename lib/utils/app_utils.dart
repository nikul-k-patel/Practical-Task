import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'app_constants.dart';
import 'slide_left_route.dart';

class AppUtils {
  AppUtils._privateConstructor();

  static final AppUtils instance = AppUtils._privateConstructor();

  static RegExp regExpEmail = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  static Future<String?> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      // SharedPreferenceUtil.putValue(strDeviceIdKey, '${iosDeviceInfo.identifierForVendor}${DateTime.now().microsecond}');
      return '${iosDeviceInfo.identifierForVendor}'; // unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      // SharedPreferenceUtil.putValue(strDeviceIdKey, '${androidDeviceInfo.id}${DateTime.now().microsecond}');
      return androidDeviceInfo.id;
    }
  }

  // void logout() {
  //   SharedPreferenceUtil.putBool(isLoginKey, false);
  //   // pushAndClearStack(enterPage: LoginScreen());
  // }

  void goBack() {
    Navigator.pop(rootNavigatorKey.currentContext!);
  }

  void pushReplacement({required Widget enterPage, bool shouldUseRootNavigator = false}) {
    ScaffoldMessenger.of(rootNavigatorKey.currentContext!).hideCurrentSnackBar();
    Navigator.of(rootNavigatorKey.currentContext!, rootNavigator: shouldUseRootNavigator).pushReplacement(
      SlideLeftRoute(page: enterPage),
    );
  }

  void push({required Widget enterPage, bool shouldUseRootNavigator = false, Function? callback, BuildContext? context}) {
    ScaffoldMessenger.of(context ?? rootNavigatorKey.currentContext!).hideCurrentSnackBar();
    FocusScope.of(context ?? rootNavigatorKey.currentContext!).requestFocus(FocusNode());
    Navigator.of(context ?? rootNavigatorKey.currentContext!, rootNavigator: shouldUseRootNavigator)
        .push(SlideLeftRoute(page: enterPage))
        .then((value) {
      callback?.call(value);
    });
  }

  Future<dynamic> pushForResult(BuildContext context, {required Widget enterPage, bool shouldUseRootNavigator = false}) {
    return Navigator.of(context, rootNavigator: shouldUseRootNavigator).push(
      SlideLeftRoute(page: enterPage),
    );
  }

  void pushAndClearStack({required Widget enterPage, bool shouldUseRootNavigator = false}) {
    ScaffoldMessenger.of(rootNavigatorKey.currentContext!).hideCurrentSnackBar();
    Navigator.of(rootNavigatorKey.currentContext!, rootNavigator: shouldUseRootNavigator)
        .pushAndRemoveUntil(SlideLeftRoute(page: enterPage), (Route<dynamic> route) => false);
  }

  // Widget commonLoader({double? size, Color? color}) {
  //   return Center(child: LoadingAnimationWidget.hexagonDots(color: color ?? colorPrimary, size: size ?? 50));
  // }

  // String getErrorMessage(dynamic error) {
  //   return error is DioException
  //       ? error.type == DioExceptionType.connectionTimeout ||
  //               error.type == DioExceptionType.receiveTimeout ||
  //               error.type == DioExceptionType.sendTimeout
  //           ? strCouldNotConnectToTheServer.tr()
  //           : error.error is SocketException
  //               ? strCheckInternetConnection.tr()
  //               : error.response != null && error.response!.data != null
  //                   ? error.response!.data!["message"]
  //                   : "An unknown error occurred"
  //       : "An unknown error occurred";
  // }

  String cardNumberHide({required String txtNum}) {
    String subNumber = (txtNum.length > 4) ? txtNum.substring(txtNum.length - 4, txtNum.length) : txtNum;
    return '**** **** **** $subNumber';
  }

  /// Get Permission ///
  // static Future<bool> handleLocationPermission() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //   var location = Location();
  //   serviceEnabled = await location.serviceEnabled();
  //   if (!serviceEnabled) {
  //     bool isServiceEnable = false;
  //     location.requestService().then((value) async {
  //       isServiceEnable = await location.serviceEnabled();
  //     });
  //
  //     showError(message: 'Location services are disabled. Please enable the services');
  //     return isServiceEnable;
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       showError(message: 'Location permissions are denied');
  //       Future.delayed(Duration(seconds: 2)).then((value) {
  //         openAppSettings();
  //       });
  //       return false;
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     Future.delayed(Duration(seconds: 2)).then((value) {
  //       openAppSettings();
  //     });
  //     showError(message: 'Location permissions are permanently denied, we cannot request permissions.');
  //     return false;
  //   }
  //   return true;
  // }

  double randomGen(int min, int max) {
    return double.tryParse('${min + Random().nextInt(max - min)}') ?? 0;
  }

  String utcToLocalDDMonthYY({String? dateString}) {
    DateTime utcDateTime = DateTime.parse(dateString!);
    DateTime localDateTime = utcDateTime.toLocal();
    return DateFormat("dd MMM yyyy").format(localDateTime).toString();
  }

  static String convertDateToDDMMYYYY({String? dateString}) {
    DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateString!).toLocal();
    DateTime dt = parseDate;
    String date = DateFormat("dd MMMM yyyy").format(dt).toString();
    return date;
  }

  String convertDateToDDMMYYYYHHFormat1({String? dateString}) {
    DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateString!, true).toLocal();
    DateTime dt = parseDate;
    String date = DateFormat("dd MMM yyyy hh:mm a").format(dt).toString();
    return date;
  }

  // static void commonDialog({required String content, required Function onTapAction, bool showCloseIcon = false}) {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: rootNavigatorKey.currentContext!,
  //     barrierColor: Colors.transparent,
  //     builder: (context) => PopScope(
  //       canPop: false,
  //       onPopInvoked: (isPop) {
  //         if (isPop == false) {
  //           return;
  //         }
  //       },
  //       child: CustomDialog(
  //         content: content,
  //         onTap: () async {
  //           Navigator.of(context, rootNavigator: true).pop();
  //           onTapAction();
  //         },
  //         showCloseIcon: showCloseIcon,
  //       ),
  //     ),
  //   );
  // }

  static String getDeviceTypeID() {
    return Platform.isAndroid ? androidDevice : iosDevice;
  }
}

void showError({String? message, Color? messageColor}) => Fluttertoast.showToast(
      msg: message.toString(),
      // backgroundColor: messageColor ?? colorFF0000,
      backgroundColor: messageColor,
      gravity: ToastGravity.TOP,
    );
void showErrorBottom({String? message, Color? messageColor}) => Fluttertoast.showToast(
      msg: message.toString(),
      // backgroundColor: messageColor ?? colorFF0000,
      backgroundColor: messageColor,
      gravity: ToastGravity.BOTTOM,
    );

void showSuccess({String? message, Color? messageColor}) => Fluttertoast.showToast(
      msg: message.toString(),
      backgroundColor: messageColor ?? Colors.green,
      gravity: ToastGravity.TOP,
    );
