import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutterquiz/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding();

  group("Login", () {
    testWidgets("with Google", (tester) async {
      app.main();
      await Future.delayed(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 5));
    });
  });
}
