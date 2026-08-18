import 'package:demo_mobile/features/tender/tender_list_controller.dart';
import 'package:demo_mobile/features/tender/tender_list_screen.dart';
import 'package:demo_mobile/features/tender/tender_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/fake_tender_api.dart';

Widget _wrap(TenderListController controller) =>
    MaterialApp(home: TenderListScreen(controller: controller));

void main() {
  testWidgets('CU-DEMO001 AC-2: bo`sh natijada "Natija topilmadi" ko`rsatiladi', (tester) async {
    final controller = TenderListController(TenderRepository(FakeTenderApi(items: const [])));

    await tester.pumpWidget(_wrap(controller));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('tender_empty_state')), findsOneWidget);
    expect(find.text('Natija topilmadi'), findsOneWidget);
  });

  testWidgets('CU-DEMO001 AC-3: xato holatida xabar ko`rinadi va ro`yxat saqlanadi', (tester) async {
    final api = FakeTenderApi(items: sampleTenders);
    final controller = TenderListController(TenderRepository(api));

    await tester.pumpWidget(_wrap(controller));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('tender_1')), findsOneWidget);

    api.shouldFail = true;
    await controller.load();
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('tender_error_message')), findsOneWidget);
    expect(find.byKey(const Key('tender_1')), findsOneWidget);
  });

  testWidgets('CU-DEMO001 AC-4: ro`yxatda summa formatlangan holda chiqadi', (tester) async {
    final controller = TenderListController(TenderRepository(FakeTenderApi(items: sampleTenders)));

    await tester.pumpWidget(_wrap(controller));
    await tester.pumpAndSettle();

    expect(find.text("12 500 000 so'm"), findsOneWidget);
  });
}
