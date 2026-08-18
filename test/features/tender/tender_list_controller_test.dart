import 'package:demo_mobile/features/tender/tender.dart';
import 'package:demo_mobile/features/tender/tender_list_controller.dart';
import 'package:demo_mobile/features/tender/tender_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/fake_tender_api.dart';

void main() {
  late FakeTenderApi api;
  late TenderListController controller;

  setUp(() {
    api = FakeTenderApi(items: sampleTenders);
    controller = TenderListController(TenderRepository(api));
  });

  test('AC-1: status filtri qo`llanganda faqat mos tenderlar qaytadi', () async {
    await controller.load(filter: TenderStatus.active);

    expect(api.lastRequestedStatus, TenderStatus.active);
    expect(controller.state.status, TenderListStatus.data);
    expect(controller.state.items.map((t) => t.id), [1, 3]);
  });

  test('AC-1: filtr olib tashlanganda barcha tenderlar qaytadi', () async {
    await controller.load(filter: TenderStatus.active);
    await controller.load(clearFilter: true);

    expect(controller.state.filter, isNull);
    expect(controller.state.items, hasLength(3));
  });

  test('AC-2: natija bo`sh bo`lganda empty holati o`rnatiladi', () async {
    api = FakeTenderApi(items: const []);
    controller = TenderListController(TenderRepository(api));

    await controller.load();

    expect(controller.state.status, TenderListStatus.empty);
    expect(controller.state.items, isEmpty);
  });

  test('AC-3: so`rov xato bo`lganda oldingi ro`yxat saqlanadi', () async {
    await controller.load();
    expect(controller.state.items, hasLength(3));

    api.shouldFail = true;
    await controller.load(filter: TenderStatus.closed);

    expect(controller.state.status, TenderListStatus.error);
    expect(controller.state.items, hasLength(3), reason: 'oldingi ro`yxat yo`qolmasligi kerak');
    expect(controller.state.errorMessage, isNotNull);
  });
}
