import 'package:demo_mobile/features/color/color_api.dart';

/// Loyihada mocking kutubxonasi ishlatilmaydi — fake'lar qo'lda yoziladi
/// (dev-rules.md §4).
class FakeColorApi implements ColorApi {
  FakeColorApi({this.status = 200, this.body, this.shouldThrow = false});

  int status;
  Map<String, dynamic>? body;
  bool shouldThrow;
  int callCount = 0;

  @override
  Future<ColorResponse> fetch() async {
    callCount++;
    if (shouldThrow) throw Exception('tarmoq xatosi');
    return ColorResponse(status, body);
  }
}
