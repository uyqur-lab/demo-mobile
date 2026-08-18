#!/usr/bin/env bash
# AC gate — spec'dagi har bir qabul mezoni uchun test bor-yo'qligini tekshiradi.
#
# Bu `/task-check` ning mexanik, LLM'siz qismi: u faqat AC ↔ test bog'lanishini
# sanaydi. Kod dalilini tekshirish va spec'dan tashqari o'zgarishlarni topish
# `/task-check` buyrug'ining vazifasi.
#
# Konvensiya: test nomi `<CU-id> AC-<raqam>:` bilan BOSHLANADI (dev-rules.md §4).
# Task id majburiy: AC raqamlari har spec ichida 1 dan boshlanadi, shuning uchun
# yolg'iz `AC-2:` boshqa taskning testiga tushib qolishi mumkin.
set -uo pipefail

TEST_DIRS="${AC_GATE_TEST_DIRS:-test integration_test}"
LAYER="${AC_GATE_LAYER:-}"          # MB | FE | BE — bo'sh bo'lsa hammasi

branch="${GITHUB_HEAD_REF:-$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo '')}"

# Spec PR'lari kod keltirmaydi — ularda AC qamrovini talab qilish mantiqsiz.
case "$branch" in
  spec/*) echo "Spec PR ($branch) — AC gate o'tkazib yuborildi"; exit 0 ;;
esac
id="$(grep -oE 'CU-[a-zA-Z0-9]+' <<<"$branch" | head -1 || true)"

if [ -z "$id" ]; then
  echo "::warning::Branch nomida CU-id yo'q ($branch) — AC gate o'tkazib yuborildi"
  exit 0
fi

spec="docs/specs/$id.md"
if [ ! -f "$spec" ]; then
  echo "::error::Spec topilmadi: $spec  →  /spec-pull $id"
  exit 1
fi

if ! grep -qE '^status:[[:space:]]*approved' "$spec"; then
  echo "::error::Spec tasdiqlanmagan: $spec (status: approved bo'lishi kerak)"
  exit 1
fi

echo "Spec: $spec"
[ -n "$LAYER" ] && echo "Qatlam: $LAYER"
echo

missing=0
total=0
covered=0
manual=0

while IFS= read -r line; do
  num="$(grep -oE 'AC-[0-9]+' <<<"$line" | head -1 | cut -d- -f2)"
  [ -z "$num" ] && continue

  # Qatlam filtri
  if [ -n "$LAYER" ]; then
    ac_layer="$(grep -oE '\[(BE|FE|MB)\]' <<<"$line" | head -1 | tr -d '[]')"
    if [ -n "$ac_layer" ] && [ "$ac_layer" != "$LAYER" ]; then
      printf 'AC-%-3s ➖ boshqa qatlam [%s]\n' "$num" "$ac_layer"
      continue
    fi
  fi

  total=$((total + 1))

  if grep -qE '(^|[[:space:]])manual:' <<<"$line"; then
    manual=$((manual + 1))
    printf 'AC-%-3s 🖐 QO`LDA — QA ro`yxatiga o`tdi\n' "$num"
    continue
  fi

  hits=0
  for d in $TEST_DIRS; do
    [ -d "$d" ] || continue
    n="$(grep -rEho "['\"]$id AC-$num:" "$d" 2>/dev/null | wc -l | tr -d ' ')"
    hits=$((hits + n))
  done

  if [ "$hits" -gt 0 ]; then
    covered=$((covered + 1))
    printf 'AC-%-3s ✅ test %s ta\n' "$num" "$hits"
  else
    missing=$((missing + 1))
    printf 'AC-%-3s ⛔ TEST YO`Q\n' "$num"
    echo "::error::AC-$num uchun test topilmadi. Test nomi \"$id AC-$num:\" bilan boshlanishi kerak."
  fi
done < <(grep -E '^-[[:space:]]+AC-[0-9]+' "$spec")

echo
echo "Jami: $total   Avtomat: $covered   Qo'lda: $manual   Qoplanmagan: $missing"

if [ "$missing" -gt 0 ]; then
  echo "GATE: YOPIQ"
  exit 1
fi

echo "GATE: OCHIQ"
