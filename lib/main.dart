import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluro/fluro.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:window_manager/window_manager.dart';

import 'helpers/constants.dart';
import 'helpers/utils.dart';

import 'configs/locator.dart';
import 'configs/routes_handler.dart';

import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = WindowOptions(
      minimumSize: Size(480, 600),
      maximumSize: Size(800, 1280),
      fullScreen: false,
      skipTaskbar: false,
      backgroundColor: Colors.transparent,
      titleBarStyle: TitleBarStyle.normal,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
  await EasyLocalization.ensureInitialized();
  await initServiceLocator();
  final router = FluroRouter();
  Routes.configureRoutes(router);
  Routes.router = router;
  await Hive.initFlutter();
  await Hive.openBox(Constants.HIVE_BOX_GENERAL);
  runApp(
    EasyLocalization(
      supportedLocales: const [ Locale(Constants.EN), Locale(Constants.ZH) ],
      path: Constants.ASSET_LOCALE,
      fallbackLocale: const Locale(Constants.EN),
      child: const MyApp(),
    ),
  );
  initEastLoading();
}
