---
clickup: CU-DEMO001
parent: CU-DEMO000
layers: [MB]
status: approved
approved_by: pm@uyqur-lab
---

# Tender ro'yxati — status bo'yicha filtrlash

## Muammo

Ta'minotchi 200+ tender ichidan o'ziga tegishlisini topa olmayapti: ro'yxat
faqat sana bo'yicha tartiblangan, filtr yo'q.

## Foydalanuvchi hikoyasi

Ta'minotchi sifatida men tenderlarni holati bo'yicha filtrlamoqchiman, chunki
menga faqat faol tenderlar kerak.

## Qabul mezonlari

- AC-1 [MB] EVENT: QACHONKI status filtri tanlansa, ro'yxatda faqat shu statusdagi tenderlar ko'rsatiladi
- AC-2 [MB] STATE: AGAR filtr natijasi bo'sh bo'lsa, "Natija topilmadi" matni ko'rsatiladi
- AC-3 [MB] UNWANTED: AGAR so'rov xato bilan tugasa, oldingi ro'yxat saqlanadi va xato xabari ko'rsatiladi
- AC-4 [MB] UBIQUITOUS: barcha summa maydonlari PriceFormatter orqali formatlanadi va bo'sh matnda istisno tashlamaydi
- AC-5 [MB] manual: filtr paneli real qurilmada bir qo'l bilan qulay boshqariladi

## API kontrakti

```
GET /api/tender/list?status=active
→ 200 {
    "items": [
      { "id": 1, "title": "Sement", "status": "active", "amount": 1250000000 }
    ],
    "total_count": 1
  }
→ 500 { "error": "internal" }
```

`amount` — tiyinda, butun son.

## Ko'lamdan tashqari

- Sana oralig'i bo'yicha filtr (keyingi task)
- Saqlanadigan filtr presetlari
- Server tomonda pagination

## Test ma'lumotlari

Muhit: dev
Hisob: `supplier@test`
Ma'lumot: kamida 1 ta `active` va 1 ta `closed` tender
