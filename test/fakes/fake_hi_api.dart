import 'package:demo_mobile/features/hi/hi_api.dart';

/// Loyihada mocking kutubxonasi ishlatilmaydi — fake'lar qo'lda yoziladi
/// (dev-rules.md §4).
class FakeHiApi implements HiApi {
  FakeHiApi({this.status = 200, this.body, this.shouldThrow = false});

  int status;
  Map<String, dynamic>? body;
  bool shouldThrow;

  int callCount = 0;
  String? lastName;
  bool? lastOmitName;

  @override
  Future<HiResponse> send({required String name, required bool omitName}) async {
    callCount++;
    lastName = name;
    lastOmitName = omitName;
    if (shouldThrow) throw Exception('tarmoq xatosi');
    return HiResponse(status, body);
  }
}
