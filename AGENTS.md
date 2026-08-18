# Agent konteksti — demo-mobile

Bu repo Uyqur AI delivery pipeline qoidalari bo'yicha ishlaydi.

## Qatlam

**MB (mobil)** — faqat `[MB]` yorlig'idagi AC'lar ustida ishlaysiz.

## Majburiy o'qish

| Fayl | Qachon |
|---|---|
| `uyqur-standards` plugin → `rules/dev-rules.md` | har ish boshida |
| `docs/specs/<CU-id>.md` | task boshida |
| `docs/conventions/` | kod yozishdan oldin |

## Ish tartibi

1. Spec `status: approved` ekanini tekshiring — `draft` bo'lsa to'xtang
2. Branch: `versions/v<ver>/CU-<id>-<slug>`
3. Kod va `AC-<n>:` bilan boshlanadigan testlar birga
4. `/task-check` → `GATE: OCHIQ`
5. `gh pr create`

## Taqiqlar

- `main` ga push yo'q, `git merge` yo'q, `gh pr merge` yo'q
- ClickUp'ga yozish yo'q — faqat o'qish
- Spec'dan tashqari refactor — alohida PR

## Loyiha konvensiyalari

- Mocking kutubxonasi yo'q — fake'lar `test/fakes/` da qo'lda yoziladi
- Summalar tiyinda, `PriceFormatter` orqali (`docs/conventions/price-formatter.md`)
