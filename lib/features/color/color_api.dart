import 'dart:convert';
import 'dart:io';

/// Kontrakt manbasi:
/// agent-standards → tasks/CU-86eyp5fw1-random-rang-api/backend.md
class ColorResponse {
  const ColorResponse(this.status, this.body);

  final int status;
  final Map<String, dynamic>? body;
}

abstract class ColorApi {
  Future<ColorResponse> fetch();
}

class HttpColorApi implements ColorApi {
  HttpColorApi({this.baseUrl = 'http://localhost:3000'});

  /// Standart manzil kontraktda ko'rsatilgani (backend.md → "Server manzili").
  final String baseUrl;

  @override
  Future<ColorResponse> fetch() async {
    final client = HttpClient();
    try {
      final request = await client.getUrl(Uri.parse('$baseUrl/api/v1/color'));
      final response = await request.close();
      final text = await response.transform(utf8.decoder).join();

      Map<String, dynamic>? body;
      try {
        final decoded = jsonDecode(text);
        if (decoded is Map<String, dynamic>) body = decoded;
      } catch (_) {
        // Javob JSON bo'lmasa body null qoladi — controller buni xato deb
        // qaraydi va foydalanuvchiga matn ko'rsatadi (AC-9).
      }

      return ColorResponse(response.statusCode, body);
    } finally {
      client.close();
    }
  }
}
