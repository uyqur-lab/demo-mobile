import 'package:demo_mobile/features/status/server_status.dart';
import 'package:demo_mobile/features/status/server_status_dot.dart';
import 'package:demo_mobile/features/tender/tender_list_controller.dart';
import 'package:demo_mobile/features/tender/tender_list_screen.dart';
import 'package:demo_mobile/features/tender/tender_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/fake_status_api.dart';
import '../../fakes/fake_tender_api.dart';

Widget _screen(ServerStatusController status) => MaterialApp(
      home: TenderListScreen(
        controller: TenderListController(
          TenderRepository(FakeTenderApi(items: sampleTenders)),
        ),
        statusController: status,
      ),
    );

Color _dotColor(WidgetTester tester) {
  final box = tester.widget<Container>(find.byKey(const Key('server_status_dot')));
  return ((box.decoration! as BoxDecoration).color)!;
}

void main() {
  testWidgets('CU-86eynqgxa AC-5: server ok bo`lsa AppBar`da yashil nuqta', (t) async {
    await t.pumpWidget(_screen(ServerStatusController(FakeStatusApi(value: 'ok'))));
    await t.pumpAndSettle();

    expect(find.byKey(const Key('server_status_dot')), findsOneWidget);
    expect(_dotColor(t), ServerStatusDot.colors[ServerStatus.ok]);
  });

  testWidgets('CU-86eynqgxa AC-6: server down bo`lsa qizil nuqta', (t) async {
    await t.pumpWidget(_screen(ServerStatusController(FakeStatusApi(value: 'down'))));
    await t.pumpAndSettle();

    expect(_dotColor(t), ServerStatusDot.colors[ServerStatus.down]);
  });

  testWidgets('CU-86eynqgxa AC-6: so`rov yiqilsa qizil nuqta', (t) async {
    await t.pumpWidget(_screen(ServerStatusController(FakeStatusApi(shouldFail: true))));
    await t.pumpAndSettle();

    expect(_dotColor(t), ServerStatusDot.colors[ServerStatus.down]);
  });
}
