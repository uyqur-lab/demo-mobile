import 'package:demo_mobile/core/price_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AC-4: summa uch xonali guruhlar bilan formatlanadi', () {
    expect(PriceFormatter.format(1250000000), "12 500 000 so'm");
    expect(PriceFormatter.format(99900), "999 so'm");
    expect(PriceFormatter.format(150), "1.50 so'm");
  });

  test('AC-4: manfiy summa minus bilan ko`rsatiladi', () {
    expect(PriceFormatter.format(-45000), "-450 so'm");
  });

  test('AC-4: bo`sh yoki noto`g`ri matnda fromPrice null qaytaradi, crash qilmaydi', () {
    expect(PriceFormatter.fromPrice(''), isNull);
    expect(PriceFormatter.fromPrice(null), isNull);
    expect(PriceFormatter.fromPrice('   '), isNull);
    expect(PriceFormatter.fromPrice('abc'), isNull);
    expect(PriceFormatter.fromPrice('-'), isNull);
  });

  test('AC-4: fromPrice haqiqiy summani tiyinga aylantiradi', () {
    expect(PriceFormatter.fromPrice('12 500'), 1250000);
    expect(PriceFormatter.fromPrice('99,50'), 9950);
  });
}
