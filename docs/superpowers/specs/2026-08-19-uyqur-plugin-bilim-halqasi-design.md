# Uyqur plagin — bilim halqasi (A-quyi-loyiha)

Sana: 2026-08-19 · Holat: dizayn tasdiqlangan · Keyingi qadam: implementatsiya rejasi

## 1. Muammo

`uyqur-standards@0.1.1` da task lifecycle'ning "spec → kod → gate → PR → QA → bug → report"
o'qi qurilgan. Yetishmayotgani — **bilim halqasi**: plagin va uning bilimi qanday
yangilanadi, va dev bo'lmagan rollar (PM, QA, Designer, Support) o'z hujjatlarini
qanday qo'shadi.

Boshlang'ich to'siq shunday qo'yilgan edi: dev'dan boshqa hech kimda GitHub yozish
huquqi yo'q va kompaniya siyosati bo'yicha berilmaydi.

**Yechim — ko'prik qurish emas, chegarani qayta chizish.** Siyosat *mahsulot*
repo'lariga taalluqli. `uyqur-lab/agent-standards` esa alohida private repo bo'lib,
har bir xodimga email orqali beriladi. Ko'prik, bot, cron — hech biri kerak emas.

## 2. Arxitektura

### 2.1 Bitta repo, ikki zona

```
uyqur-lab/agent-standards          (private · email orqali share)
├── .claude-plugin/plugin.json     ← VERSIYA shu yerda
├── commands/ rules/ hooks/ templates/ install/   ┐ PLAGIN zonasi
│                                                 ┘ o'zgarsa → versiya ko'tariladi
└── tasks/CU-<id>-<slug>/          ┐ DATA zonasi
      ├── doc.md        (PM)       │ o'zgarsa → versiya TEGILMAYDI
      ├── backend.md    (BE)       │
      ├── front.md      (FE)       │
      ├── mobile.md     (MB)       │
      ├── qa.md         (QA)       │
      └── issue.md      (QA)       ┘
```

Zonalarni ajratish uchun maxsus kod yozilmaydi — Claude Code buni o'zi qiladi.
`plugin.json` da `version` maydoni ko'rsatilgan bo'lsa, yangi commit'lar
foydalanuvchilarda update chaqirmaydi; versiya faqat qo'lda ko'tarilganda xabar
tarqaladi. `version` ni tushirib qoldirish esa har commit'ni update qilib
ko'rsatadi — bizga bu kerak emas.

**Nega zonalar kerak:** `tasks/` kuniga o'nlab marta o'zgaradi va hech kimni
bezovta qilmasligi shart. `rules/` oyiga bir marta o'zgaradi va o'zgarganda
hammaga yetib borishi shart. Bir xil versiyaga bog'lansa, ikkinchisi birinchisining
shovqinida ko'rinmay ketadi.

### 2.2 Har mashinada ikki nusxa

| Nusxa | Joy | Kim boshqaradi | Vazifa |
|---|---|---|---|
| Plagin cache | `~/.claude/plugins/cache/uyqur/…/<ver>/` | Claude Code | Buyruq, qoida, hook — faqat o'qish |
| **Oyna klon** | `~/.uyqur/agent-standards/` | plagin (`git`) | `tasks/` ni o'qish va yozish |

Ikkitasining sababi: plagin cache git checkout **emas** (tekshirilgan: `.git` yo'q)
va har `/plugin update` da qayta yoziladi — u yerga yozilgan narsa yo'qoladi.

Claude Code marketplace'ning haqiqiy klonini `~/.claude/plugins/marketplaces/uyqur/`
da saqlaydi, lekin **unga yozmaymiz**: u Claude Code'ning ichki holati va
`marketplace update` uni reset qilishi mumkin.

### 2.3 Yozish yo'llari

```
ClickUp  ← plagin foydalanuvchining o'z huquqi bilan yozadi (status, task)
GitHub   ← plagin oyna klonga commit + push qiladi (har kimda huquq bor)
```

Bot ham, secret ham, cron ham yo'q.

## 3. Sessiya boshi (SessionStart hook)

```
git -C ~/.uyqur/agent-standards fetch --quiet
├─ plugin.json versiyasi o'rnatilganidan yangimi?
│     → chatda: "⬆ Plagin: 0.1.1 → 0.2.0 · /plugin update"
└─ faqat tasks/ o'zgarganmi?
      → jim git pull → chatda: "📄 CU-86ey… da yangi issue.md"
```

Hisobot faqat foydalanuvchining o'z tasklariga tegishli o'zgarishlar uchun beriladi.

## 4. Rollar va chegaralar

### 4.1 `/setup`

```
/setup
 ├─ 1. Rol: PM · DEV · QA
 ├─ 2. DEV bo'lsa → stack (BE/FE/MB) va mahsulot repo'si
 ├─ 3. ClickUp MCP bormi? yo'q bo'lsa — o'rnatishni taklif qiladi
 ├─ 4. git clone → ~/.uyqur/agent-standards
 └─ 5. yozadi → ~/.uyqur/config.json  { role, stack, repo }
```

Rol va stack Claude xotirasiga ham yoziladi, keyingi sessiyalarda qayta so'ralmaydi.

### 4.2 Yozish ruxsatlari

| Rol | `tasks/CU-…/` ichida yoza oladi | Plagin zonasi |
|---|---|---|
| PM | `doc.md` | ❌ |
| DEV | `backend.md` / `front.md` / `mobile.md` (o'z stack'i) | ✅ faqat PR orqali |
| QA | `qa.md`, `issue.md` | ❌ |

Designer va Support bu jadvalga kirmaydi — ular D-quyi-loyihada hal bo'ladi.

### 4.3 Majburlash — hook, model emas

Ruxsat `hooks/scripts/role-guard.sh` (PreToolUse, matcher `Write|Edit|Bash`)
tomonidan majburlanadi. Hook `config.json` dan rolni o'qiydi va ruxsat etilgan
fayl naqshidan tashqaridagi har yozuvni `exit 2` bilan bloklaydi.

Qoida `rules/` da matn sifatida ham yoziladi, lekin **majburlash hook'da**:
model ishontirishga beriladi, hook berilmaydi.

**Cheklov, ochiq aytilgan:** `config.json` foydalanuvchining o'z mashinasida
yotadi va uni tahrirlash mumkin. Bu tasodifdan va yengil suiiste'moldan himoya,
qasddan buzuvchidan emas. Haqiqiy qulf — CODEOWNERS + branch protection, u esa
private repo'da GitHub Team plan talab qiladi.

## 5. Task lifecycle

Quyidagi jadval — **to'liq xarita**, A ning yetkazmasi emas. A faqat papka
kelishuvini, `/setup` ni va `role-guard.sh` ni beradi; buyruqlarning o'zi
belgilangan quyi-loyihalarda yoziladi.

| # | Bosqich | Rol | Buyruq | `tasks/CU-…/` | ClickUp | Loyiha |
|---|---|---|---|---|---|---|
| 1 | Yaratish | PM | `/task-new` | `doc.md` yoziladi | task + BE/FE/MB sub-tasklar | **A** |
| 2 | Boshlash | DEV | `/task-start <link\|id>` yoki "bugungi tasklarim" | **barcha `.md` o'qiladi** | task topiladi | **B** |
| 3 | Tekshirish | DEV | `/task-check` | `<stack>.md` yoziladi | — | **A** |
| 4 | Test | QA | `/qa-brief` → `/qa-result` | `qa.md` yoziladi | — | **C** |
| 5 | Issue | QA | `/qa-issue` | `issue.md` yoziladi | taskka izoh | **C** |
| 6 | Rework | DEV | `/task-fix` | `<stack>.md` yangilanadi | — | **C** |
| 7 | Hisobot | PM | `/pm-report` | hammasi o'qiladi | — | **A** |

### 5.1 `<stack>.md` — qatlamlararo kontrakt

`backend.md` muallif uchun emas, **keyingi qatlam uchun** yoziladi: qanday API
qo'shildi, so'rov/javob shakli qanday, natijani qayerda va qanday ko'rsatish kerak.
FE va MB ish boshlashdan oldin uni o'qiydi.

Buning ikki oqibati bor:

1. `/task-start` faqat `doc.md` ni emas, `tasks/CU-…/` dagi **barcha** `.md` ni o'qiydi.
2. Jonli `fetch` — qulaylik emas, majburiyat. `/task-start` har safar `fetch` bilan
   boshlanadi, aks holda MB devi eskirgan kontraktga kod yozadi.

Tizimning asl qiymati shu: **BE→FE/MB uzatmasini yig'ilishsiz o'tkazish.**

### 5.2 Fayl egaligi

`tasks/CU-…/` ichidagi har fayl **yagona egaga** ega. Shuning uchun bir vaqtda
ishlayotgan besh kishi bitta repo'ga push qilsa ham git konflikti bo'lmaydi —
ular hech qachon bitta faylga tegmaydi. `role-guard.sh` ham shu sababli sodda:
u faqat "bu fayl sening rolingnikimi?" deb so'raydi.

## 6. Mavjud komponentlar taqdiri

| Komponent | Nima bo'ladi |
|---|---|
| `/spec-pull` | `/task-new` ichiga so'riladi — PM endi Claude bilan brainstorming qiladi |
| `/task-check` | Qoladi; spec manzili `docs/specs/` → `~/.uyqur/agent-standards/tasks/` |
| `/qa-brief` | Kengayadi (`/qa-result`, `/qa-issue` qo'shiladi) |
| `/pm-report` | Deyarli o'zgarmaydi |
| `/bug-triage` | **A dan chiqadi** — cross-repo CI buyrug'i edi; C da `/task-fix` ga qayta o'ylanadi |
| `.github/scripts/ac-gate.sh` | **Olib tashlanadi** — AC gate CI'da emas, lokal `/task-check` da |
| `.github/workflows/bot-report.yml` | Olib tashlanadi (AC gate va ClickUp status qismi) |
| `.github/workflows/ci.yml` | **Qoladi** — `dart analyze` + `flutter test` odatdagidek |
| `hooks/scripts/block-direct-push.sh` | Qoladi |

**Qabul qilingan oqibat:** CI gate ketgach `/task-check` to'liq maslahat xarakterida
qoladi — uni chaqirish devning o'z ixtiyorida. Status surish ham majburiy emas:
imkon bo'lsa ClickUp MCP orqali, bo'lmasa dev qo'lda qiladi.

## 7. Demo ko'lami

**Demo A ning o'zi bilan ishlamaydi** — u A, B va C ning **birgalikdagi
qabul sinovi**. Shuning uchun B va C spec'lari A dan keyin darhol, qisqa
shaklda yoziladi va uchalasi bitta demoda tekshiriladi.

Full process bitta mashinada, `config.json` dagi rolni almashtirib aylantiriladi.
Ikkinchi repo kerak emas: BE ning demodagi mahsuloti kod emas, **hujjat** —
`backend.md` API kontraktini tasvirlaydi, MB devi uni `uyqur-lab-demo` (Flutter)
repo'sida implementatsiya qiladi. Repo'dagi mavjud `test/fakes/fake_tender_api.dart`
kontraktning tushish nuqtasi bo'ladi.

Zanjir:

```
/setup PM  → /task-new
/setup BE  → backend.md
/setup MB  → /task-start → kod → /task-check
/setup QA  → /qa-brief → /qa-issue
/setup MB  → /task-fix
```

Demo muvaffaqiyatli hisoblanadi, agar: har rol faqat o'ziga ruxsat etilgan faylni
yoza olsa, MB devi `backend.md` ni ko'rmasdan turib ishni boshlay olmasa, va
`issue.md` MB sessiyasida `fetch` orqali o'zi paydo bo'lsa.

## 8. Birinchi kunda tekshiriladigan xavflar

1. **Private marketplace.** Repo hozir public. Uni private qilib, boshqa
   mashinada `claude plugin marketplace add uyqur-lab/agent-standards` ni
   sinash kerak. Claude Code git credential helper'larini ishlatadi
   (`gh auth login` / Keychain / SSH), lekin buni amalda ko'rish shart.
   Ma'lum nuqsonlar: Windows'da SSH bug'i (claude-code#20589), `GITHUB_TOKEN`
   klonlashda ishlatilmasligi (claude-code#17201).
2. **Branch himoyasi data zonasini bloklaydi — implementatsiyada aniqlandi, HAL QILINMAGAN.**

   `agent-standards` ning asosiy branchida "o'zgarish faqat PR orqali" qoidasi
   va `verify` nomli majburiy status check bor. Ya'ni PM va QA task hujjatlarini
   to'g'ridan-to'g'ri yubora **olmaydi** — GitHub ularni rad etadi. Demoda bu
   faqat admin huquqi bilan chetlab o'tildi.

   Bu §2.3 dagi "har kim o'z hujjatini yozadi" modelining asosini yeydi.
   Uchta yechim bor:

   | Yechim | Narxi |
   |---|---|
   | PR talabini olib tashlash | Plagin zonasi ham himoyasiz qoladi; review madaniyatga tayanadi |
   | Ikki branch: plagin `main` da, `tasks/` alohida himoyalanmagan branchda | Ikki branch sinxronizatsiyasi, murakkabroq oyna klon |
   | `tasks/` ni alohida repo'ga chiqarish | Ikki repo, ikki klon; bitta repo g'oyasi buziladi |

   Eslatma: repo private qilinganda bepul org'da branch protection kuchini
   yo'qotadi va muammo o'z-o'zidan yopiladi — lekin bu tasodifiy yechim,
   dizayn emas.

3. **`tasks/` hajmi.** Yuzlab tasklardan keyin klon og'irlashadi. Zaxira yo'l:
   `marketplace add --sparse` yoki `git-subdir` manba turi.

## 9. Ko'lamdan tashqari

Bu spec faqat **A-quyi-loyihani** qamraydi: repo tuzilishi, ikki zona, oyna klon,
sessiya boshidagi tekshiruv, `/setup`, rollar va `role-guard.sh`.

Alohida spec oladiganlar:

- **B** — kirish nuqtasi: `/task-start`, "bugungi tasklarim", ClickUp MCP taklifi
- **C** — rework halqasi: `/qa-brief`, `/qa-result`, `/qa-issue`, `/task-fix`,
  `/bug-triage` ning taqdiri
- **D** — Designer va Support rollari

B va C — A ga bog'liq (papka kelishuvi va `/setup` ularsiz ishlamaydi), lekin
bir-biriga bog'liq emas. D mustaqil va kutishi mumkin.
