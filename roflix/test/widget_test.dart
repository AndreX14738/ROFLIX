
import 'package:flutter_test/flutter_test.dart';

import 'package:roflix/main.dart';

void main() {
  testWidgets('ROFLIX app test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
  await tester.pumpWidget(const MyApp());

    // Verify that the login screen loads
    expect(find.text('ROFLIX'), findsOneWidget);
    expect(find.text('Inicia sesión en tu cuenta'), findsOneWidget);
  });
}
