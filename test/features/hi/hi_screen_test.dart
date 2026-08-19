import 'package:demo_mobile/features/hi/hi_controller.dart';
import 'package:demo_mobile/features/hi/hi_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/fake_hi_api.dart';

Widget _app(HiController c) => MaterialApp(home: HiScreen(controller: c));

String _resultText(WidgetTester tester) =>
    tester.widget<Text>(find.byKey(const Key('result'))).data ?? '';

void main() {
  testWidgets('CU-86eyp4nmg AC-7: tugma bosilganda javob ekranda ko`rinadi',
      (tester) async {
    final api = FakeHiApi(status: 200, body: {'message': 'hi Alisher'});
    await tester.pumpWidget(_app(HiController(api)));

    await tester.tap(find.text('Yubor'));
    await tester.pumpAndSettle();

    expect(_resultText(tester), 'hi Alisher');
  });

  testWidgets('CU-86eyp4nmg AC-8: xato ekranda matn bilan ko`rinadi',
      (tester) async {
    final api = FakeHiApi(status: 400, body: {'error': 'name_required'});
    await tester.pumpWidget(_app(HiController(api)));

    await tester.tap(find.text('Yubor'));
    await tester.pumpAndSettle();

    expect(_resultText(tester), 'Ism yuborilmadi');
  });

  testWidgets('CU-86eyp4nmg AC-8: xatoda natija maydoni bo`sh qolmaydi',
      (tester) async {
    final api = FakeHiApi(shouldThrow: true);
    await tester.pumpWidget(_app(HiController(api)));

    await tester.tap(find.text('Yubor'));
    await tester.pumpAndSettle();

    expect(_resultText(tester).isNotEmpty, isTrue);
  });
}
