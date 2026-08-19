import 'package:demo_mobile/features/color/color_api.dart';
import 'package:demo_mobile/features/color/color_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/fake_color_api.dart';

void main() {
  test('CU-86eyp5fw1 AC-7: color qiymati matn sifatida o`zgartirilmaydi', () async {
    final c = ColorController(FakeColorApi(body: {'color': 'ffffff'}));
    await c.load();

    expect(c.view.kind, ColorViewKind.ok);
    expect(c.view.code, 'ffffff');
  });

  test('CU-86eyp5fw1 AC-7: matnga # qo`shilmaydi', () async {
    final c = ColorController(FakeColorApi(body: {'color': '00ff2a'}));
    await c.load();

    expect(c.view.code, '00ff2a');
    expect(c.view.code.contains('#'), isFalse);
  });

  test('CU-86eyp5fw1 AC-7: harf registri o`zgartirilmaydi', () async {
    final c = ColorController(FakeColorApi(body: {'color': 'abcdef'}));
    await c.load();

    expect(c.view.code, 'abcdef');
  });

  test('CU-86eyp5fw1 AC-7: boshidagi nollar saqlanadi', () async {
    final c = ColorController(FakeColorApi(body: {'color': '000000'}));
    await c.load();

    expect(c.view.code, '000000');
    expect(c.view.code.length, 6);
  });

  test('CU-86eyp5fw1 AC-8: rang qiymati kod bilan mos keladi', () async {
    final c = ColorController(FakeColorApi(body: {'color': '04300b'}));
    await c.load();

    // Matn va rang — ikki alohida narsa. Rang `#` bilan quriladi,
    // matn esa tegilmaydi (backend.md).
    expect(c.view.color, const Color(0xFF04300B));
    expect(c.view.code, '04300b');
  });

  test('CU-86eyp5fw1 AC-9: naqshga mos kelmagan kod — xato', () {
    // backend.md: uzunlik 6 dan farq qilsa bu server xatosi,
    // klient uni to'ldirmaydi.
    final view = ColorController.toView(const ColorResponse(200, {'color': 'ff2a'}));

    expect(view.kind, ColorViewKind.error);
    expect(view.text.isNotEmpty, isTrue);
  });

  test('CU-86eyp5fw1 AC-9: bosh harfli kod ham xato deb qaraladi', () {
    final view = ColorController.toView(const ColorResponse(200, {'color': 'FFFFFF'}));

    expect(view.kind, ColorViewKind.error);
  });

  test('CU-86eyp5fw1 AC-9: tarmoq xatosida matn bo`sh qolmaydi', () async {
    final c = ColorController(FakeColorApi(shouldThrow: true));
    await c.load();

    expect(c.view.kind, ColorViewKind.error);
    expect(c.view.text.isNotEmpty, isTrue);
  });

  test('CU-86eyp5fw1 AC-9: 404 javobda xom kod ko`rsatilmaydi', () async {
    final c = ColorController(
      FakeColorApi(status: 404, body: {'error': 'not_found'}),
    );
    await c.load();

    expect(c.view.kind, ColorViewKind.error);
    expect(c.view.text.contains('not_found'), isFalse);
  });
}
