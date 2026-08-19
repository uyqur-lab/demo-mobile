import 'package:flutter/material.dart';

import 'color_api.dart';

enum ColorViewKind { initial, loading, ok, error }

@immutable
class ColorView {
  const ColorView({required this.kind, this.code = '', this.text = '', this.color});

  final ColorViewKind kind;

  /// Serverdan kelgan kod — **o'zgartirilmagan** holda. Ekranga shu chiqadi.
  final String code;

  /// Xato yoki holat matni (kod bo'lmaganda ko'rsatiladi).
  final String text;

  /// Namuna rangi. `#` shu yerda qo'shiladi, `code` da emas.
  final Color? color;
}

/// Mantiq widget'dan ajratilgan — shuning uchun testlanadi (AGENTS.md).
class ColorController extends ChangeNotifier {
  ColorController(this._api);

  final ColorApi _api;

  /// Kontrakt: 6 belgi, kichik harf, `#` yo'q (backend.md).
  static final RegExp hexPattern = RegExp(r'^[0-9a-f]{6}$');

  static const String fallbackText = "Ulanmadi. Keyinroq urinib ko'ring";

  ColorView _view = const ColorView(kind: ColorViewKind.initial);
  ColorView get view => _view;

  void _emit(ColorView next) {
    _view = next;
    notifyListeners();
  }

  /// Javobni ekranga tushadigan holatga aylantiradi.
  ///
  /// Kod naqshga mos kelmasa — bu **server xatosi**. Klient uni to'ldirmaydi
  /// va tuzatmaydi (backend.md → "Qabul qilingan qarorlar"). Aks holda
  /// buzilgan qiymat rangga aylanadi va xato jim o'tib ketadi.
  static ColorView toView(ColorResponse response) {
    final code = response.body?['color'];
    if (response.status == 200 && code is String && hexPattern.hasMatch(code)) {
      return ColorView(
        kind: ColorViewKind.ok,
        code: code,
        color: Color(int.parse('FF$code', radix: 16)),
      );
    }

    return const ColorView(kind: ColorViewKind.error, text: fallbackText);
  }

  Future<void> load() async {
    _emit(const ColorView(kind: ColorViewKind.loading, text: 'Olinmoqda…'));
    try {
      _emit(toView(await _api.fetch()));
    } catch (_) {
      // Tarmoq yiqilsa ham natija maydoni bo'sh qolmaydi (AC-9).
      _emit(const ColorView(kind: ColorViewKind.error, text: fallbackText));
    }
  }
}
