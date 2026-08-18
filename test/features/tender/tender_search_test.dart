import 'package:demo_mobile/features/tender/tender_list_controller.dart';
import 'package:demo_mobile/features/tender/tender_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/fake_tender_api.dart';

void main() {
  test('CU-DEMO003 AC-1: qidiruv matni nomiga mos tenderlarni qoldiradi', () async {
    final controller = TenderListController(
      TenderRepository(FakeTenderApi(items: sampleTenders)),
    );
    await controller.load();

    controller.search('sement');

    expect(controller.visibleItems.map((t) => t.id), [1]);
  });
}
