import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:todo/main.dart' as app;
import 'package:todo/helpers/constants.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('To-Do List App', (tester) async {
    await tester.pumpApp();
    expect(find.text(Constants.APP_NAME), findsNothing);
  });

}

extension on WidgetTester {
  Future<void> pumpApp() async {
    app.main();
    await pumpAndSettle();
  }
}
