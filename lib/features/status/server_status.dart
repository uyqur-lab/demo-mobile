import 'package:flutter/foundation.dart';

/// Kontrakt: uyqur-lab/contracts → GET /api/status → { "status": "ok" | "down" }
abstract class StatusApi {
  Future<String> fetchStatus();
}

enum ServerStatus { checking, ok, down }

/// So'rov ekran ochilganda bir marta yuboriladi (PM qarori — davriy emas).
class ServerStatusController extends ChangeNotifier {
  ServerStatusController(this._api);
  final StatusApi _api;

  ServerStatus _status = ServerStatus.checking;
  ServerStatus get status => _status;

  Future<void> load() async {
    try {
      final value = await _api.fetchStatus();
      _status = value == 'ok' ? ServerStatus.ok : ServerStatus.down;
    } catch (_) {
      // Tarmoq xatosi ham "down" — foydalanuvchi uchun farqi yo'q.
      _status = ServerStatus.down;
    }
    notifyListeners();
  }
}
