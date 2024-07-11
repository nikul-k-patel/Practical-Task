import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../resources/color.dart';

void launchCall(String phoneNumber) async {
  Uri call = Uri.parse('tel:$phoneNumber');
  await launchUrl(call);
}

void launchEmail(String emailAddress) async {
  Uri mail = Uri.parse("mailto:$emailAddress");
  await launchUrl(mail);
}

void launchWhatsApp(String phoneNumber) async {
  Uri call = Uri.parse("whatsapp://send?phone=$phoneNumber");
  await launchUrl(call);
}

bool isDateBefore(String sFromData, String sToDate) {
  DateTime fromData = DateFormat('dd/MM/yyyy').parse(sFromData);
  DateTime toData = DateFormat('dd/MM/yyyy').parse(sToDate);
  return fromData.isBefore(toData);
}

String localTimestamp(String timestamp) {
  Intl.defaultLocale = 'en_US';
  DateTime dateTime = DateTime.parse(timestamp);
  String formattedTime = DateFormat('hh:mm a').format(dateTime.toLocal());
  return formattedTime;
}

(String, String) convertDateTimeFormat(String dateString) {
  try {
    Intl.defaultLocale = 'en_US';
    DateTime originalDate = DateTime.parse(dateString);
    DateFormat outputDateFormat = DateFormat('dd/MM/yyyy');
    DateFormat outputTimeFormat = DateFormat('hh:mm a');
    String formattedDate = outputDateFormat.format(originalDate);
    String formattedTime = outputTimeFormat.format(originalDate);
    print('dDate==>$formattedDate==$formattedTime');
    return (formattedDate, formattedTime);
  } catch (e) {
    log('Error: ${e.toString()}');
    return ('', '');
  }
}

(String, String) convertDateTimeUTC2LocalFormat(String dateString) {
  try {
    Intl.defaultLocale = 'en_US';
    DateTime originalDate = DateTime.parse(dateString).toUtc();
    DateTime localDate = originalDate.toLocal();
    DateFormat outputDateFormat = DateFormat('dd/MM/yyyy');
    DateFormat outputTimeFormat = DateFormat('hh:mm a');
    String formattedDate = outputDateFormat.format(localDate);
    String formattedTime = outputTimeFormat.format(localDate);
    log('Date: $formattedDate, Time: $formattedTime');
    return (formattedDate, formattedTime);
  } catch (e) {
    log('Error: $e');
    return ('', '');
  }
}

String convertDateFormat({String? dateString, String? inFormat = 'dd MMMM yyyy', String? opFormat = 'dd MMMM yyyy'}) {
  Intl.defaultLocale = 'en_US';
  log('==> Date: $dateString --- $inFormat --- $opFormat }');
  if (dateString!.contains('null')) return '';
  try {
    DateTime originalDate = DateFormat(inFormat).parse(dateString);
    String formattedDate = DateFormat(opFormat).format(originalDate);
    return formattedDate;
  } catch (e) {
    log('==> Date: $dateString --- $inFormat --- $opFormat --- ${e.toString()}');
  }
  return dateString;
}

String formatHM2JMTime(String time) {
  if (time.isEmpty) {
    return "";
  }
  print('N==>$time');
  final DateTime parsedTime = DateFormat.Hm().parse(time);
  final String formattedTime = DateFormat.jm().format(parsedTime);
  return formattedTime;
}

bool validateVehiclePlate(String plate) {
  RegExp regex = RegExp(r'^[A-Z]{3}\d[A-Z]\d{2}$');
  return regex.hasMatch(plate);
}

List<DateTime> generateDateList(int numberOfDays) {
  List<DateTime> dateList = [];
  DateTime currentDate = DateTime.now().add(const Duration(days: 1));
  for (int i = 0; i < numberOfDays; i++) {
    DateTime nextDate = currentDate.add(Duration(days: i));
    dateList.add(nextDate);
  }

  return dateList;
}

class UppercaseTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class AlphabeticInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text.replaceAll(RegExp(r'[^a-zA-Z]'), '');

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class OnlyNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text.replaceAll(RegExp('[^0-9]'), '');

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class NumberDotInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text.replaceAll(RegExp('r[^0-9]-.'), '');

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

Widget heightBox(double height) {
  return SizedBox(height: height);
}

Widget widthBox(double width) {
  return SizedBox(width: width);
}

Widget commonLoader({double? size, Color? color}) {
  return Center(
    child: LoadingAnimationWidget.hexagonDots(
      color: color ?? colorPrimary,
      size: size ?? 48,
    ),
    // LoadingAnimationWidget.staggeredDotsWave(
    //   color: color ?? colorPrimary,
    //   size: size ?? 48,
    // ),
  );
}

Widget commonLoader2({double? size, Color? color}) {
  return Center(
    child: LoadingAnimationWidget.hexagonDots(
      color: color ?? colorPrimary,
      size: size ?? 48,
    ),
    // LoadingAnimationWidget.hexagonDots(
    //   color: color ?? colorPrimary,
    //   size: size ?? 48,
    // ),
  );
}

Widget screenLoader({double? size, Color? color}) {
  return Center(
    child: LoadingAnimationWidget.hexagonDots(
      color: color ?? colorED2730,
      size: size ?? 48,
    ),
  );
}

Widget paginationLoader({double? size, Color? color}) {
  return Center(
    child: LoadingAnimationWidget.prograssiveDots(
      color: color ?? colorED2730,
      size: size ?? 56,
    ),
  );
}

Widget lineSeparator({required Size size, double? width, double? height, Color? color}) {
  return Container(
    height: height ?? 1.h,
    width: width ?? size.width,
    color: color ?? colorDDDDDD,
  );
}
