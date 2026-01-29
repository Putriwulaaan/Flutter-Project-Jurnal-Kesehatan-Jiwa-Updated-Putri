import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_journal/main.dart'; // Pastikan ini sesuai nama project Anda

void main() {
  test('Simple smoke test', () {
    expect(1 + 1, 2);
  });

  testWidgets('App loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(MyApp), findsOneWidget);
  });
}
