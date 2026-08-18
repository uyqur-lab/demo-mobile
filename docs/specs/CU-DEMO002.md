---
clickup: CU-DEMO002
parent: CU-DEMO000
layers: [MB]
status: approved
approved_by: pm@uyqur-lab
---

# Tender ro'yxati — sana oralig'i bo'yicha filtr

## Muammo

Status filtri qo'shilgandan keyin ham ro'yxat uzun qolmoqda: ta'minotchi
odatda faqat oxirgi hafta tenderlarini ko'radi.

## Foydalanuvchi hikoyasi

Ta'minotchi sifatida men tenderlarni sana oralig'i bo'yicha cheklamoqchiman,
chunki eski tenderlar menga kerak emas.

## Qabul mezonlari

- AC-1 [MB] EVENT: QACHONKI sana oralig'i tanlansa, ro'yxatda faqat shu oraliqdagi tenderlar ko'rsatiladi
- AC-2 [MB] UNWANTED: AGAR boshlanish sanasi tugash sanasidan keyin bo'lsa, so'rov yuborilmaydi va "Sana oralig'i noto'g'ri" xabari ko'rsatiladi
- AC-3 [MB] manual: sana tanlash oynasi kichik ekranli qurilmada to'liq ko'rinadi

## API kontrakti

```
GET /api/tender/list?status=active&date_from=2026-08-01&date_to=2026-08-31
→ 200 { "items": [...], "total_count": n }
```

Sanalar ISO-8601 (`YYYY-MM-DD`), inklyuziv.

## Ko'lamdan tashqari

- Tayyor oraliqlar ("oxirgi 7 kun") — keyingi task

## Test ma'lumotlari

Muhit: dev, hisob `supplier@test`, turli sanalardagi kamida 3 ta tender
