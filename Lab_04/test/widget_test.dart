import 'package:flutter_test/flutter_test.dart';

import 'package:lab_04/main.dart';

void main() {
  testWidgets('shows average and updates grades', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('ממוצע: 66.3'), findsOneWidget);
    expect(find.text('ציון: 54'), findsOneWidget);

    await tester.tap(find.byTooltip('הוסף').at(2));
    await tester.pump();

    expect(find.text('ציון: 55'), findsOneWidget);
  });
}
