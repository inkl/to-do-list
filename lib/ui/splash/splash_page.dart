import 'package:flutter/material.dart';

import 'package:after_layout/after_layout.dart';
import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluro/fluro.dart';

import '/helpers/constants.dart';
import '/helpers/styles.dart';
import '/helpers/colors.dart';

import '/configs/routes_handler.dart';

class SplashPage extends StatefulWidget {

  const SplashPage({Key? key}) : super(key: key);

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> with AfterLayoutMixin<SplashPage> {

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    loadData();
  }

  init() async {

  }

  Future loadData() async {

    // Delay 1 seconds on the Splash screen before navigate to next pages.
    Future.delayed(const Duration(milliseconds: 2000), () async {
      Routes.router.navigateTo(context, Routes.dashboard, replace: true, transition: TransitionType.none);
    });

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.YELLOW,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(0.0),
            child: AppBar(
              backgroundColor: AppColors.WHITE,
              elevation: 0.0,
              title: Text(Constants.APP_NAME, style: appBarTitleDarkTextStyle),
            ),
          ),
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints viewportConstraints) {
              return Container(
                margin: EdgeInsets.only(top: viewportConstraints.maxHeight / 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeInDown(
                      child: Text('AppName'.tr(), style: splashTitleTextStyle),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

}
