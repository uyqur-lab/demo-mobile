# Agent konteksti — demo-mobile

Bu repo Uyqur AI delivery pipeline qoidalari bo'yicha ishlaydi.

## Qatlam

**MB (mobil)** — faqat `[MB]` yorlig'idagi AC'lar ustida ishlaysiz.

## Majburiy o'qish

| Fayl | Qachon |
|---|---|
| `~/.uyqur/agent-standards/rules/dev-rules.md` | har ish boshida |
| `~/.uyqur/agent-standards/tasks/CU-<id>-*/` — **barcha** `.md` | task boshida |
| `docs/conventions/` | kod yozishdan oldin |

Task hujjatlari bu repo'da emas, oyna klonda yashaydi. `backend.md` sizga API
kontraktini beradi — uni o'qimasdan kod yozmang.

## Ish tartibi

1. `/task-start <CU-id>` — hujjatlar o'qiladi, brief beriladi, branch ochiladi
2. Kod va `<CU-id> AC-<n>:` bilan boshlanadigan testlar birga
3. `/task-check` → `GATE: OCHIQ` va `mobile.md` yoziladi
4. `gh pr create`

## Taqiqlar

- Himoyalangan branch'larga to'g'ridan-to'g'ri yetkazish yo'q
- Lokal birlashtirish va PR'ni yopish — inson qarori
- ClickUp'ga yozish yo'q — dev faqat o'qiydi
- Hujjatdan tashqari refactor — alohida PR
- Boshqa qatlamning `<stack>.md` fayliga yozish yo'q — u faqat o'qish uchun

Batafsil: `rules/dev-rules.md` §3 va `rules/role-rules.md`.

## Loyiha konvensiyalari

- Mocking kutubxonasi yo'q — fake'lar `test/fakes/` da qo'lda yoziladi
- Mantiq widget'dan ajratiladi: controller/model testlanadi, ekran ulaydi
