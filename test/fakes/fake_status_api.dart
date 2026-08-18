import 'package:demo_mobile/features/status/server_status.dart';

class FakeStatusApi implements StatusApi {
  FakeStatusApi({this.value = 'ok', this.shouldFail = false});
  final String value;
  final bool shouldFail;

  @override
  Future<String> fetchStatus() async {
    if (shouldFail) throw Exception('tarmoq xatosi');
    return value;
  }
}
