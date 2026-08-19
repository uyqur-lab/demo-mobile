import 'package:flutter/foundation.dart';

import 'hi_api.dart';

enum HiViewKind { initial, loading, ok, error }

@immutable
class HiView {
  const HiView({required this.kind, this.text = ''});

  final HiViewKind kind;
  final String text;
}

/// Mantiq widget'dan ajratilgan — shuning uchun testlanadi (AGENTS.md).
class HiController extends ChangeNotifier {
  HiController(this._api);

  final HiApi _api;

  /// Xato kodlari → foydalanuvchi matni. Jadval `backend.md` dan olingan;
  /// xom kod (`name_required`) foydalanuvchiga ko'rsatilmaydi.
  static const Map<String, String> errorText = {
    'name_required': 'Ism yuborilmadi',
    'invalid_body': "So'rov noto'g'ri yuborildi",
  };

  static const String fallbackText = "Ulanmadi. Keyinroq urinib ko'ring";

  HiView _view = const HiView(kind: HiViewKind.initial);
  HiView get view => _view;

  void _emit(HiView next) {
    _view = next;
    notifyListeners();
  }

  /// Javobni ekranga tushadigan holatga aylantiradi.
  static HiView toView(HiResponse response) {
    final message = response.body?['message'];
    if (response.status == 200 && message is String) {
      // Trim qilinmaydi: bo'sh ism uchun javob "hi " va u shundayligicha
      // ko'rsatiladi (backend.md).
      return HiView(kind: HiViewKind.ok, text: message);
    }

    final code = response.body?['error'];
    final text = code is String ? errorText[code] : null;
    return HiView(kind: HiViewKind.error, text: text ?? fallbackText);
  }

  Future<void> send({required String name, required bool omitName}) async {
    _emit(const HiView(kind: HiViewKind.loading, text: 'Yuborilmoqda…'));
    try {
      final response = await _api.send(name: name, omitName: omitName);
      _emit(toView(response));
    } catch (_) {
      // Tarmoq yiqilsa ham natija maydoni bo'sh qolmaydi (AC-8).
      _emit(const HiView(kind: HiViewKind.error, text: fallbackText));
    }
  }
}
