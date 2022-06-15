import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

class Constants {

  // Hardcoded text.
  static const String APP_NAME = 'To-Do List App';
  static const String LOCALE = 'locale';

  // Date formatted.
  static const String FORMAT_DATE1 = 'dd MMM yyyy';
  static const String FORMAT_DATE2 = 'yyyy年 M月 dd日';
  static const String FORMAT_DATE3 = 'dd/MM/yyyy';

  // This is for Hive NoSQL Database.
  static const String HIVE_BOX_GENERAL = 'general';
  static const String HIVE_TO_DO = 'todo';

  // This is string path for the asset images.
  static const String PATH_ICON_BOOKMARK = 'assets/images/icon_bookmark.png';
  static const String PATH_ICON_BOOKMARKED = 'assets/images/icon_bookmarked.png';
  static const String PATH_ICON_DELETE = 'assets/images/icon_delete.png';

  // Locales file path.
  static const String ASSET_LOCALE = 'assets/translations';

  // Font type.
  static const String FONT_CALIBRI = 'Calibri';

  // This is value for supported locales.
  static const String ZH = 'zh';
  static const String EN = 'en';

  // This is value for font size.
  static const double FONT_16 = 16.0;
  static const double FONT_18 = 18.0;
  static const double FONT_20 = 20.0;
  static const double FONT_24 = 24.0;
  static const double FONT_32 = 32.0;

  static double font16 = 16.sp;
  static double font18 = 18.sp;
  static double font20 = 20.sp;
  static double font24 = 24.sp;
  static double font32 = 32.sp;

}
