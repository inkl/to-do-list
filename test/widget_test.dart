import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:todo/helpers/constants.dart';
import 'package:todo/ui/splash/splash_page.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {

  group('Splash Screen', () {
    testWidgets('Displays splash message', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: SplashPage(),
          ),
        );

        expect(find.text('AppName'.tr()), findsOneWidget);
      });
    });

    testWidgets('Should push routes correctly', (tester) async {
      final mockObserver = MockNavigatorObserver();
      final splashRoute = MaterialPageRoute(builder: (_) => Container());
      final dashboardRoute = MaterialPageRoute(builder: (_) => Container(color: Colors.white, child: Text(Constants.APP_NAME)));
      const splash = '/splash';
      const dashboard = '/dashboard';
      await tester.runAsync(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Container(),
            navigatorObservers: [mockObserver],
            onGenerateRoute: (RouteSettings settings) {
              switch (settings.name) {
                case splash:
                  return splashRoute;
                case dashboard:
                  return dashboardRoute;
              }
              return null;
            },
          ),
        );

        final BuildContext context = tester.element(find.byType(Container));

        // Verify that a push to splashRoute happened.
        navigateToNumber(splash, context);
        await tester.pumpAndSettle();
        verify(mockObserver.didPush(splashRoute, any));

        // Verify that a push to dashboardRoute happened.
        navigateToNumber(dashboard, context);
        await tester.pumpAndSettle();
        verify(mockObserver.didPush(dashboardRoute, any));

        // To be sure that dashboard page is now present in the screen.
        expect(find.text(Constants.APP_NAME), findsOneWidget);
      });
    });
  });

}

navigateToNumber(String routes, BuildContext context) => Navigator.of(context).pushNamed(routes);

// @GenerateMocks([], customMocks: [ MockSpec<NavigatorObserver>(returnNullOnMissingStub: true) ] )
