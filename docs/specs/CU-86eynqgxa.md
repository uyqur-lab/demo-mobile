---
clickup: CU-86eynqgxa
layers: [BE, FE, MB]
status: approved
approved_by: pm@uyqur
---

# Server holati indikatori

## Muammo

Foydalanuvchi ilova serverga ulana olayotganini bilmaydi. Ma'lumot
yuklanmasa, sabab tarmoqdami yoki serverdami — tushunarsiz.

## Foydalanuvchi hikoyasi

Foydalanuvchi sifatida men server ishlayotganini bir qarashda ko'rmoqchiman.

## Qabul mezonlari

- AC-1 [BE] EVENT: QACHONKI `GET /api/status` chaqirilsa, tizim 200 va `{"status":"ok"}` qaytaradi
- AC-2 [BE] UNWANTED: AGAR ichki xatolik bo'lsa, U HOLDA tizim 503 va `{"status":"down"}` qaytaradi
- AC-3 [FE] EVENT: QACHONKI bosh sahifa yuklansa, `/api/status` so'raladi va `status` = `ok` bo'lsa yashil indikator ko'rsatiladi
- AC-4 [FE] UNWANTED: AGAR so'rov yiqilsa yoki `status` ≠ `ok` bo'lsa, qizil indikator ko'rsatiladi
- AC-5 [MB] EVENT: QACHONKI asosiy ekran ochilsa, `/api/status` so'raladi va `status` = `ok` bo'lsa AppBar o'ng tomonida yashil indikator ko'rsatiladi
- AC-6 [MB] UNWANTED: AGAR so'rov yiqilsa yoki `status` ≠ `ok` bo'lsa, qizil indikator ko'rsatiladi
- AC-7 [MB] manual: indikator rangi kunduzgi yorug'likda ajralib turadi

## Qarorlar (PM tasdiqlagan)

- Endpoint: `/api/status`
- Xato holati: **qizil** indikator (kulrang emas)
- Mobil: AppBar o'ng tomonida
- So'rov: ekran ochilganda bir marta, davriy emas

## API kontrakti

```
GET /api/status
→ 200  { "status": "ok" }
→ 503  { "status": "down" }
```

Kontrakt manbasi: `uyqur-lab/contracts` → `openapi/v1.yaml`

## Ko'lamdan tashqari

- Server javob vaqtini ko'rsatish
- Tarixiy uptime statistikasi
- Push orqali holat xabari

## Test ma'lumotlari

Backend lokal `http://localhost:3000`. "down" holatini sinash uchun
serverni to'xtatish yetarli.
