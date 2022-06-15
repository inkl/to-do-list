import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sized_context/sized_context.dart';

import 'colors.dart';
import 'constants.dart';

// This is the config for easy loading indicator.
void initEastLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..loadingStyle = EasyLoadingStyle.custom
    ..maskType = EasyLoadingMaskType.none
    ..indicatorSize = 40.0
    ..radius = 8.0
    ..progressColor = AppColors.TRANSPARENT
    ..backgroundColor = AppColors.GRAY_LIGHT.withOpacity(0.5)
    ..indicatorColor = AppColors.ORANGE
    ..textColor = AppColors.TRANSPARENT
    ..boxShadow = <BoxShadow>[]
    ..userInteractions = false;
}

// Check device locale is Chinese.
bool isChinese(BuildContext context) {
  return context.deviceLocale.languageCode == Constants.ZH;
}

// Check device is small screen or mobile.
bool isSmallScreenView(BuildContext context) {
  return context.widthPx < 600;
}

// Convert milliseconds timestamp to DateTime in String.
String? formatTimestamp(int? ms, String fmt) {
  if (ms == null) return null;
  var dateTime = DateTime.fromMillisecondsSinceEpoch(ms);
  var formattedDate = '${DateFormat(fmt).format(dateTime)}';
  return formattedDate;
}

// This extension is for compare given datetime is today, yesterday, ot tomorrow.
extension DateHelpers on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return yesterday.day == day && yesterday.month == month && yesterday.year == year;
  }

  bool isTomorrow() {
    final tomorrow = DateTime.now().add(Duration(days: 1));
    return tomorrow.day == day && tomorrow.month == month && tomorrow.year == year;
  }
}
