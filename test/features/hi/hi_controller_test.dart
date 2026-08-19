import 'package:demo_mobile/features/hi/hi_api.dart';
import 'package:demo_mobile/features/hi/hi_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/fake_hi_api.dart';

void main() {
  test('CU-86eyp4nmg AC-7: javobdagi message natijaga tushadi', () async {
    final api = FakeHiApi(status: 200, body: {'message': 'hi Alisher'});
    final c = HiController(api);

    await c.send(name: 'Alisher', omitName: false);

    expect(c.view.kind, HiViewKind.ok);
    expect(c.view.text, 'hi Alisher');
  });

  test('CU-86eyp4nmg AC-7: bo`sh ism javobi trim qilinmaydi', () async {
    // backend.md: bo'sh ism uchun javob "hi " — orqasidagi bo'shliq bilan.
    final api = FakeHiApi(status: 200, body: {'message': 'hi '});
    final c = HiController(api);

    await c.send(name: '', omitName: false);

    expect(c.view.text, 'hi ');
  });

  test('CU-86eyp4nmg AC-7: so`rov ism va omitName bilan yuboriladi', () async {
    final api = FakeHiApi(status: 200, body: {'message': 'hi Ali'});
    final c = HiController(api);

    await c.send(name: 'Ali', omitName: false);

    expect(api.callCount, 1);
    expect(api.lastName, 'Ali');
    expect(api.lastOmitName, false);
  });

  test('CU-86eyp4nmg AC-8: name_required o`z matni bilan ko`rsatiladi', () async {
    final api = FakeHiApi(status: 400, body: {'error': 'name_required'});
    final c = HiController(api);

    await c.send(name: '', omitName: true);

    expect(c.view.kind, HiViewKind.error);
    expect(c.view.text, 'Ism yuborilmadi');
  });

  test('CU-86eyp4nmg AC-8: invalid_body o`z matni bilan ko`rsatiladi', () async {
    final api = FakeHiApi(status: 400, body: {'error': 'invalid_body'});
    final c = HiController(api);

    await c.send(name: 'x', omitName: false);

    expect(c.view.text, "So'rov noto'g'ri yuborildi");
  });

  test('CU-86eyp4nmg AC-8: tarmoq xatosida matn bo`sh qolmaydi', () async {
    final api = FakeHiApi(shouldThrow: true);
    final c = HiController(api);

    await c.send(name: 'x', omitName: false);

    expect(c.view.kind, HiViewKind.error);
    expect(c.view.text.isNotEmpty, isTrue);
  });

  test('CU-86eyp4nmg AC-8: noma`lum error kodi xom holda ko`rsatilmaydi', () async {
    final api = FakeHiApi(status: 500, body: {'error': 'boshqa_narsa'});
    final c = HiController(api);

    await c.send(name: 'x', omitName: false);

    expect(c.view.kind, HiViewKind.error);
    expect(c.view.text.contains('boshqa_narsa'), isFalse);
    expect(c.view.text, HiController.fallbackText);
  });

  test('CU-86eyp4nmg AC-8: 200 lekin message yo`q — xato deb qaraladi', () {
    final view = HiController.toView(const HiResponse(200, {}));

    expect(view.kind, HiViewKind.error);
    expect(view.text.isNotEmpty, isTrue);
  });
}
