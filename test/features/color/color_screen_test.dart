import 'package:demo_mobile/features/color/color_controller.dart';
import 'package:demo_mobile/features/color/color_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/fake_color_api.dart';

Widget _app(ColorController c) => MaterialApp(home: ColorScreen(controller: c));

String _codeText(WidgetTester tester) =>
    tester.widget<Text>(find.byKey(const Key('color-code'))).data ?? '';

Container _swatch(WidgetTester tester) =>
    tester.widget<Container>(find.byKey(const Key('color-swatch')));

void main() {
  testWidgets('CU-86eyp5fw1 AC-7: kod ekranda o`zgartirilmasdan ko`rinadi',
      (tester) async {
    final c = ColorController(FakeColorApi(body: {'color': '04300b'}));
    await tester.pumpWidget(_app(c));

    await tester.tap(find.text('Rang ol'));
    await tester.pumpAndSettle();

    expect(_codeText(tester), '04300b');
  });

  testWidgets('CU-86eyp5fw1 AC-8: namuna 48×48 va radius 8 bo`ladi',
      (tester) async {
    final c = ColorController(FakeColorApi(body: {'color': 'ffffff'}));
    await tester.pumpWidget(_app(c));

    await tester.tap(find.text('Rang ol'));
    await tester.pumpAndSettle();

    final swatch = _swatch(tester);
    final box = swatch.decoration as BoxDecoration;

    expect(swatch.constraints?.maxWidth, 48);
    expect(swatch.constraints?.maxHeight, 48);
    expect(box.borderRadius, BorderRadius.circular(8));
    expect(box.color, const Color(0xFFFFFFFF));
  });

  testWidgets('CU-86eyp5fw1 AC-9: xatoda natija maydoni bo`sh qolmaydi',
      (tester) async {
    final c = ColorController(FakeColorApi(shouldThrow: true));
    await tester.pumpWidget(_app(c));

    await tester.tap(find.text('Rang ol'));
    await tester.pumpAndSettle();

    expect(_codeText(tester).isNotEmpty, isTrue);
  });
}
