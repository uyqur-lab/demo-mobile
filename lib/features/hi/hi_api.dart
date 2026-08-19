import 'dart:convert';
import 'dart:io';

/// Kontrakt manbasi:
/// agent-standards → tasks/CU-86eyp4nmg-salomlashish-api/backend.md
class HiResponse {
  const HiResponse(this.status, this.body);

  final int status;
  final Map<String, dynamic>? body;
}

abstract class HiApi {
  /// [omitName] — `name` maydonini butunlay yubormaslik uchun. Bo'sh input
  /// bo'sh matn yuboradi, `null` emas; 400 yo'lini sinash uchun alohida
  /// boshqaruv kerak (doc.md, PM qarori 2).
  Future<HiResponse> send({required String name, required bool omitName});
}

class HttpHiApi implements HiApi {
  HttpHiApi({this.baseUrl = 'http://localhost:3000'});

  /// Standart manzil kontraktda ko'rsatilgani (backend.md → "Server manzili").
  final String baseUrl;

  @override
  Future<HiResponse> send({required String name, required bool omitName}) async {
    final client = HttpClient();
    try {
      final request = await client.postUrl(Uri.parse('$baseUrl/api/v1/hi'));
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(omitName ? <String, dynamic>{} : {'name': name}));

      final response = await request.close();
      final text = await response.transform(utf8.decoder).join();

      Map<String, dynamic>? body;
      try {
        final decoded = jsonDecode(text);
        if (decoded is Map<String, dynamic>) body = decoded;
      } catch (_) {
        // Javob JSON bo'lmasa body null qoladi — controller buni xato deb
        // qaraydi va foydalanuvchiga matn ko'rsatadi (AC-8).
      }

      return HiResponse(response.statusCode, body);
    } finally {
      client.close();
    }
  }
}
