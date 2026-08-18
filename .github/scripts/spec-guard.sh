#!/usr/bin/env bash
# CI gate: branch nomidagi CU-id uchun tasdiqlangan spec bor-yo'qligini tekshiradi.
# Bu `/task-check` ning to'liq o'rnini bosmaydi — u faqat eng qo'pol xatoni ushlaydi.
set -euo pipefail

branch="${GITHUB_HEAD_REF:-$(git rev-parse --abbrev-ref HEAD)}"
id="$(grep -oE 'CU-[a-zA-Z0-9]+' <<<"$branch" | head -1 || true)"

if [ -z "$id" ]; then
  echo "::warning::Branch nomida CU-id yo'q: $branch"
  exit 0
fi

spec="docs/specs/$id.md"
if [ ! -f "$spec" ]; then
  echo "::error::Spec topilmadi: $spec  →  /spec-pull $id"
  exit 1
fi

if ! grep -qE '^status:[[:space:]]*approved' "$spec"; then
  echo "::error::Spec tasdiqlanmagan: $spec (status: approved emas)"
  exit 1
fi

acs="$(grep -cE '^- AC-[0-9]+' "$spec" || true)"
echo "✓ $spec — tasdiqlangan, $acs ta AC"
