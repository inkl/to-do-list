import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:after_layout/after_layout.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sized_context/sized_context.dart';

import '/helpers/enums.dart';
import '/helpers/utils.dart';
import '/helpers/colors.dart';
import '/helpers/argument.dart';
import '/helpers/styles.dart';
import '/helpers/constants.dart';

import '/stores/base_store.dart';

import '/ui/widgets/dialogs.dart';

class DetailsPage extends StatefulWidget {

  final BaseArguments? arguments;

  const DetailsPage({Key? key, required this.arguments}) : super(key: key);

  @override
  DetailsPageState createState() => DetailsPageState();
}

class DetailsPageState extends State<DetailsPage> with AfterLayoutMixin<DetailsPage> {

  var _baseStore = BaseStore();

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    _baseStore.disposeDetails();
    super.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    loadData();
  }

  init() async {

    // Here to retrieve the arguments from previous pages.
    var arguments = widget.arguments;
    if (arguments != null) _baseStore = arguments.store;

    // Get ready for startup the details pages.
    _baseStore.initDetails();
  }

  Future loadData() async {
    // This is to handle keyboard visibility. Used to hide some widgets in the pages.
    if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android)) {
      var keyboardVisibilityController = KeyboardVisibilityController();
      keyboardVisibilityController.onChange.listen((bool visible) {
        _baseStore.setKeyboardOpened(visible);
      });
    }

  }

  void submit() async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.focusedChild?.unfocus();
    }

    await Future.delayed(Duration(milliseconds: 100));

    var title = _baseStore.titleController.text;
    var startDate = _baseStore.getTodoListData?.startDate;
    var endDate = _baseStore.getTodoListData?.endDate;

    if (title.isEmpty || startDate == null || endDate == null) {
      return showStatusWidget('FieldRequired'.tr(), false);
    } else {
      _baseStore.save();
    }
  }

  Widget listViewWidget() {
    return Expanded(
      child: Observer(
        builder: (_) {
          var startDate = _baseStore.getTodoListData?.startDate;
          var endDate = _baseStore.getTodoListData?.endDate;

          // Format the timestamp to readable datetime string base on locales.
          var startDateString = formatTimestamp(startDate, isChinese(context) ? Constants.FORMAT_DATE2 : Constants.FORMAT_DATE1);
          var endDateString = formatTimestamp(endDate, isChinese(context) ? Constants.FORMAT_DATE2 : Constants.FORMAT_DATE1);
          return ListView(
            padding: EdgeInsets.only(bottom: 30.0),
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('ToDoTitle'.tr(), textAlign: TextAlign.left, style: textStyleLabel18),
                    SizedBox(height: 15.0),
                    TextFormField (
                      controller: _baseStore.titleController,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      minLines: 1,
                      maxLines: 8,
                      style: textStyleLabel16,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(1.0)),
                          borderSide: BorderSide(
                            color: AppColors.BLACK,
                            width: 1.0,
                          ),
                        ),
                        filled: true,
                        hintStyle: textStyleHint16,
                        hintText: 'ToDoTitleHint'.tr(),
                        fillColor: AppColors.WHITE,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('StartDate'.tr(), textAlign: TextAlign.left, style: textStyleLabel18),
                    SizedBox(height: 15.0),
                    GestureDetector(
                      onTap: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }

                        // This is to show the calender widget. CalenderEnum.STARTED is define for started date.
                        _baseStore.showCalenderPicker(context, CalenderEnum.STARTED);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                        decoration: BoxDecoration(
                          color: AppColors.WHITE,
                          borderRadius: BorderRadius.all(Radius.circular(1.0)),
                          border: Border.all(
                            color: AppColors.BLACK,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(startDateString ?? 'SelectDateHint'.tr(), style: startDateString == null ? textStyleHint16 : textStyleLabel16),
                            ),
                            SizedBox(width: 10.0),
                            Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('EstimateEndDate'.tr(), textAlign: TextAlign.left, style: textStyleLabel18),
                    SizedBox(height: 15.0),
                    GestureDetector(
                      onTap: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }

                        // This is to show the calender widget. CalenderEnum.ENDED is define for ended date.
                        _baseStore.showCalenderPicker(context, CalenderEnum.ENDED);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                        decoration: BoxDecoration(
                          color: AppColors.WHITE,
                          borderRadius: BorderRadius.all(Radius.circular(1.0)),
                          border: Border.all(
                            color: AppColors.BLACK,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(endDateString ?? 'SelectDateHint'.tr(), style: endDateString == null ? textStyleHint16 : textStyleLabel16),
                            ),
                            SizedBox(width: 10.0),
                            Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buttonWidget() {
    return Observer(
      builder: (_) => Visibility(
        visible: !_baseStore.getKeyboardOpened,
        child: Container(
          width: context.mq.size.width,
          padding: EdgeInsets.symmetric(vertical: 15.0),
          decoration: BoxDecoration(
            color: _baseStore.getIsEditing ? AppColors.ORANGE : AppColors.BLACK,
          ),
          child: TextButton(
            onPressed: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.focusedChild?.unfocus();
              }

              submit();
            },
            child: Text(_baseStore.getIsEditing ? 'UpdateNow'.tr() : 'CreateNow'.tr(), style: textStyleButton18),
          ),
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
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.SILVER,
          appBar: AppBar(
            backgroundColor: AppColors.YELLOW,
            toolbarHeight: 60.0,
            title: Text(_baseStore.getIsEditing ? 'EditTitle'.tr() : 'AddNewTitle'.tr(), style: appBarTitleDarkTextStyle),
            centerTitle: false,
            elevation: 2.0,
            titleSpacing: 0.0,
            leading: IconButton(
              iconSize: 18.0,
              icon: Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.focusedChild?.unfocus();
                }

                Navigator.pop(context);
              },
            ),
            iconTheme: IconThemeData(color: AppColors.BLACK),
          ),
          body: Column(
            children: [
              listViewWidget(),
              buttonWidget(),
            ],
          ),
        ),
      ),
    );
  }

}
