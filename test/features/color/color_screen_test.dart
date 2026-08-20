import 'dart:async';

import 'package:demo_mobile/features/color/color_api.dart';
import 'package:demo_mobile/features/color/color_controller.dart';
import 'package:demo_mobile/features/color/color_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/fake_color_api.dart';

Widget _app(ColorController c) => MaterialApp(home: ColorScreen(controller: c));

String _codeText(WidgetTester tester) =>
    tester.widget<Text>(find.byKey(const Key('color-code'))).data ?? '';

Container _swatch(WidgetTester tester) =>
    tester.widget<Container>(find.byKey(const Key('color-swatch')));

void main() {
  testWidgets(
    'CU-86eyp5fw1 AC-1/AC-2: ok holatda kod nusxalanadi va tasdiq ko`rinadi',
    (tester) async {
      final c = ColorController(FakeColorApi(body: {'color': '04300b'}));
      await tester.pumpWidget(_app(c));

      String? copied;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {
            copied = (call.arguments as Map)['text'] as String?;
          }
          return null;
        },
      );

      await tester.tap(find.text('Rang ol'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('copy-color-code')), findsOneWidget);

      await tester.tap(find.byKey(const Key('copy-color-code')));
      await tester.pump();

      expect(copied, '04300b');
      expect(find.text('Kod nusxalandi'), findsOneWidget);

      tester.binding.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    },
  );

  testWidgets(
    'CU-86eyp5fw1 AC-3: initial/loading/error holatlarida nusxalash tugmasi yo`q',
    (tester) async {
      final initial = ColorController(FakeColorApi(body: {'color': '04300b'}));
      await tester.pumpWidget(_app(initial));
      expect(find.byKey(const Key('copy-color-code')), findsNothing);

      final loading = ColorController(_PendingColorApi());
      await tester.pumpWidget(_app(loading));
      await tester.tap(find.text('Rang ol'));
      await tester.pump();
      expect(find.byKey(const Key('copy-color-code')), findsNothing);

      final error = ColorController(FakeColorApi(shouldThrow: true));
      await tester.pumpWidget(_app(error));
      await tester.tap(find.text('Rang ol'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('copy-color-code')), findsNothing);
    },
  );

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

class _PendingColorApi implements ColorApi {
  @override
  Future<ColorResponse> fetch() => Completer<ColorResponse>().future;
}
