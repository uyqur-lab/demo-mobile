# demo-mobile

Uyqur AI delivery pipeline poligoni. Bu repo haqiqiy mahsulot emas — jarayonni
sinash uchun minimal Flutter loyihasi.

## Nima namoyish qiladi

- `docs/specs/CU-DEMO001.md` — EARS formatidagi tasdiqlangan spec
- `test/` — har test nomi `AC-<n>:` bilan boshlanadi (traceability)
- `.github/workflows/ci.yml` — analyze + test + spec-guard
- `.claude/settings.json` — `uyqur-standards` plugin va ClickUp yozish taqiqi
- `AGENTS.md` — agent uchun qatlam va qoidalar

## Ishga tushirish

```bash
flutter pub get
flutter test
flutter analyze
```

## Jarayon

Batafsil: [uyqur-lab/agent-standards](https://github.com/uyqur-lab/agent-standards)
