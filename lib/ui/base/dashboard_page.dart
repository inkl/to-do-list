import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'dart:io';
import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:countdown_widget/countdown_widget.dart';
import 'package:sizer/sizer.dart';

import '/helpers/colors.dart';
import '/helpers/styles.dart';
import '/helpers/constants.dart';
import '/helpers/argument.dart';
import '/helpers/utils.dart';

import '/configs/routes_handler.dart';

import '/models/data_model.dart';

import '/stores/base_store.dart';

import '/ui/widgets/appbar.dart';

class DashboardPage extends StatefulWidget {

  const DashboardPage({Key? key}) : super(key: key);

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> with WidgetsBindingObserver, AfterLayoutMixin<DashboardPage> {

  final _baseStore = BaseStore();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
    } else if (state == AppLifecycleState.resumed) {
    } else if (state == AppLifecycleState.inactive) {
    } else if (state == AppLifecycleState.detached) {
    }

    // Checking app state is in foreground or background.
    _baseStore.globalState.isInForeground = state == AppLifecycleState.resumed;
  }

  @override
  void afterFirstLayout(BuildContext context) {
    loadData();
  }

  init() async {

    // Get ready for startup the current pages.
    _baseStore.initBaseData();

  }

  Future loadData() async {

  }

  buildListView() {
    return Expanded(
      child: Observer(
        builder: (_) {
          // Show empty pages if Hive database haven't initialized.
          if (!_baseStore.getIsLoadedHive) return Container();
          var list = _baseStore.getTodoList;
          // Show empty data description on the screen if no data found.
          if (list.isEmpty) {
            return Center(
              child: SizedBox(
                width: 30.h,
                child: Text('NoDataDesc'.tr(), textAlign: TextAlign.center, style: textStyleLabel18),
              ),
            );
          }
          return ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                itemCount: list.length,
                itemBuilder: (_, int index) {
                  return Observer(
                    builder: (_) {
                      TodoListBase data = list[index];
                      return todoContentWidget(index, data);
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget todoContentWidget(int index, TodoListBase data) {
    var title = data.title;
    var startDate = data.startDate;
    var endDate = data.endDate;

    // Format the timestamp to readable datetime string base on locales.
    var startDateString = formatTimestamp(startDate, isChinese(context) ? Constants.FORMAT_DATE3 : Constants.FORMAT_DATE1);
    var endDateString = formatTimestamp(endDate, isChinese(context) ? Constants.FORMAT_DATE3 : Constants.FORMAT_DATE1);

    // Compare the different with the end date timestamp.
    Duration duration = DateTime.fromMillisecondsSinceEpoch(data.endDate!).difference(DateTime.now());

    // Get the status for the to-do items. If checked means completed.
    String status = data.checked ? 'Completed'.tr() : 'InComplete'.tr();
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }

        // Here to set details page is editing. [true] is for update to-do items.
        _baseStore.setIsEditing(true);
        _baseStore.setTodoListData(data);

        // Navigate to the details page with arguments.
        Routes.router.navigateTo(context, Routes.details, routeSettings: RouteSettings(arguments: BaseArguments(_baseStore)), transition: TransitionType.none);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
          color: AppColors.WHITE,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              child: Text('$title', style: textStyleTitle24),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text('StartDate'.tr(), style: textStyleLabel16),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('EndDate'.tr(), style: textStyleLabel16),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('TimeLeft'.tr(), style: textStyleLabel16),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text('$startDateString', style: textStyleTitle16),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('$endDateString', style: textStyleTitle16),
                  ),
                  Expanded(
                    flex: 1,
                    child: CountDownWidget(
                      duration: duration,
                      builder: (context, duration) {
                        return Text('TimeLeftParams'.tr(args: ['${duration.inHours.toString()}', '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}']), style: textStyleTitle16);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
              decoration: BoxDecoration(
                color: AppColors.GREY,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Status'.tr(), style: textStyleLabel16),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: Text('$status', style: data.checked ? textStyleTitleGreen18 : textStyleTitle18),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('TickDesc'.tr(), style: textStyleLabel16),
                        Observer(
                          builder: (_) => Checkbox(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                            side: MaterialStateBorderSide.resolveWith((states) => BorderSide(width: 1.0, color: AppColors.GRAY_DARK)),
                            checkColor: AppColors.ORANGE,
                            fillColor: MaterialStateProperty.all(AppColors.TRANSPARENT),
                            value: data.checked,
                            onChanged: (bool? value) async {
                              data.checked = !data.checked;

                              _baseStore.update();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // To close the keyboard (if visible) when press anywhere in app.
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }

      },
      child: WillPopScope(
        onWillPop: () {
          // To handle back key button (hardware) pressed on some devices.
          var doubleTap = _baseStore.onBackPressed();
          if (doubleTap) {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            return Future.value(true);
          } else {
            return Future.value(false);
          }
        },
        child: SafeArea(
          bottom: kIsWeb ? false : Platform.isAndroid,
          child: Scaffold(
            backgroundColor: AppColors.WHITE,
            appBar: CustomAppBar(title: 'AppName'.tr()),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.focusedChild?.unfocus();
                }

                // Here to set details page is not editing. [false] is for create new to-do items.
                _baseStore.setIsEditing(false);

                // Navigate to the details page with arguments.
                Routes.router.navigateTo(context, Routes.details, routeSettings: RouteSettings(arguments: BaseArguments(_baseStore)), transition: TransitionType.none);
              },
              child: Icon(Icons.add, color: AppColors.WHITE),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            body: Container(
              padding: EdgeInsets.only(top: 10.0),
              color: AppColors.SILVER,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildListView(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
