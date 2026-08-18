import 'package:demo_mobile/features/tender/tender_list_controller.dart';
import 'package:demo_mobile/features/tender/tender_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/fake_tender_api.dart';

void main() {
  test('CU-DEMO002 AC-1: sana oralig`i tanlanganda faqat shu oraliqdagi tenderlar qaytadi', () async {
    final api = FakeTenderApi(items: sampleTenders);
    final controller = TenderListController(TenderRepository(api));

    await controller.load(
      from: DateTime(2026, 8, 5),
      to: DateTime(2026, 8, 15),
    );

    expect(api.lastFrom, DateTime(2026, 8, 5));
    expect(controller.state.items.map((t) => t.id), [2]);
  });

  test('CU-DEMO002 AC-2: teskari sana oralig`ida so`rov yuborilmaydi', () async {
    final api = FakeTenderApi(items: sampleTenders);
    final controller = TenderListController(TenderRepository(api));

    await controller.load(
      from: DateTime(2026, 8, 20),
      to: DateTime(2026, 8, 5),
    );

    expect(api.callCount, 0, reason: 'API chaqirilmasligi kerak');
    expect(controller.state.status, TenderListStatus.error);
    expect(controller.state.errorMessage, "Sana oralig'i noto'g'ri");
  });
}
