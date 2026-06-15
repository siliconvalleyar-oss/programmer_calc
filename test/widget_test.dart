import 'package:flutter_test/flutter_test.dart';
import 'package:pcalc_app/main.dart';

void main() {
  testWidgets('App renders and shows PCALC title', (WidgetTester tester) async {
    await tester.pumpWidget(const PcalcApp());
    expect(find.text('PCALC'), findsWidgets);
  });
}
