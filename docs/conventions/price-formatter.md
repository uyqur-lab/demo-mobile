# Summa maydonlari

## Qoida

Foydalanuvchiga ko'rinadigan har qanday pul qiymati `PriceFormatter.format()`
orqali o'tadi. To'g'ridan-to'g'ri `toString()` yoki `NumberFormat` ishlatilmaydi.

## Saqlash birligi

Summalar **tiyinda, butun son** sifatida saqlanadi va uzatiladi. `double`
ishlatilmaydi — suzuvchi nuqta xatosi hisob-kitobda to'planadi.

## `fromPrice` xavfsizligi

`PriceFormatter.fromPrice()` bo'sh, `null` yoki noto'g'ri matnda **`null`
qaytaradi** va hech qachon istisno tashlamaydi. Sabab: bu funksiya matn
kiritish maydonlariga ulanadi va foydalanuvchi maydonni tozalaganda har
safar chaqiriladi.

Chaqiruvchi tomon `null` ni tekshirishi shart:

```dart
final tiyin = PriceFormatter.fromPrice(controller.text);
if (tiyin == null) return; // bo'sh maydon — hech narsa qilinmaydi
```
