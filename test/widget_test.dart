import 'package:flutter_test/flutter_test.dart';
import 'package:gr_merch/main.dart';

void main() {
  testWidgets('GR Merchandise app renders main sections', (WidgetTester tester) async {
    await tester.pumpWidget(const GrMerchApp());
    expect(find.text('PRODUCT'), findsWidgets);
    expect(find.text('NEW ARRIVALS'), findsWidgets);
    expect(find.text('LOKASI OUTLET'), findsWidgets);
    expect(find.text('ABOUT'), findsWidgets);
  });
}
