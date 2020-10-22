import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plant_diary/login_page.dart';

void main() {
  testWidgets('Login button enabled test', (WidgetTester tester) async {
    // Adding MaterialApp as an ancestor because MediaQuery ancestor is needed in LoginPage to be built corectly.
    await tester.pumpWidget(MaterialApp(
      home: LoginPage(),
    ));

    // Log in button should be disabled before email and password are entered
    expect(tester.widget<FlatButton>(find.byKey(Key('LOGIN'))).enabled, false);

    await tester.enterText(find.byKey(Key('EMAIL')), 'test@example.com');
    await tester.enterText(find.byKey(Key('PASSWORD')), 'testPassword');

    expect(find.text('test@example.com'), findsOneWidget);
    expect(find.text('testPassword'), findsOneWidget);

// rebuild the widget after entering email and password
    await tester.pump();

    // Log in button should be enabled afrer email and password are entered
    expect(tester.widget<FlatButton>(find.byKey(Key('LOGIN'))).enabled, true);
  });
}
