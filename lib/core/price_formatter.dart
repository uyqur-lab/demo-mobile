/// Summa maydonlarini formatlash. Loyihada barcha pul qiymatlari shu klass
/// orqali o'tadi (docs/conventions/price-formatter.md).
class PriceFormatter {
  const PriceFormatter._();

  /// Tiyindagi butun qiymatni o'qiladigan matnga aylantiradi.
  /// 1234567 → "12 345.67 so'm"
  static String format(int amountInTiyin, {String suffix = "so'm"}) {
    final negative = amountInTiyin < 0;
    final abs = amountInTiyin.abs();
    final whole = abs ~/ 100;
    final cents = abs % 100;

    final buffer = StringBuffer();
    final digits = whole.toString();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }

    final centsPart = cents == 0 ? '' : '.${cents.toString().padLeft(2, '0')}';
    return '${negative ? '-' : ''}$buffer$centsPart $suffix';
  }

  /// Foydalanuvchi kiritgan matndan tiyindagi qiymatni oladi.
  /// Bo'sh yoki noto'g'ri matnda `null` qaytaradi — istisno tashlamaydi.
  static int? fromPrice(String? raw) {
    if (raw == null) return null;
    final cleaned = raw.replaceAll(RegExp(r'[^0-9.,-]'), '').replaceAll(',', '.');
    if (cleaned.isEmpty || cleaned == '-' || cleaned == '.') return null;
    final value = double.tryParse(cleaned);
    if (value == null) return null;
    return (value * 100).round();
  }
}
