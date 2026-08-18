import 'package:demo_mobile/features/status/server_status.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/fake_status_api.dart';

void main() {
  test('CU-86eynqgxa AC-5: status=ok bo`lganda holat ok bo`ladi', () async {
    final c = ServerStatusController(FakeStatusApi(value: 'ok'));
    await c.load();
    expect(c.status, ServerStatus.ok);
  });

  test('CU-86eynqgxa AC-6: status=down bo`lganda holat down bo`ladi', () async {
    final c = ServerStatusController(FakeStatusApi(value: 'down'));
    await c.load();
    expect(c.status, ServerStatus.down);
  });

  test('CU-86eynqgxa AC-6: so`rov yiqilsa holat down bo`ladi', () async {
    final c = ServerStatusController(FakeStatusApi(shouldFail: true));
    await c.load();
    expect(c.status, ServerStatus.down);
  });
}
