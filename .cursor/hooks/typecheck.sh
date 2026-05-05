#!/bin/bash
input=$(cat)

if ! command -v npx &> /dev/null; then
  echo '{ "additional_context": "Skipped type check: npx not found." }'
  exit 0
fi

output=$(npx tsc --noEmit 2>&1)
exit_code=$?

if [ $exit_code -ne 0 ]; then
  errors=$(echo "$output" | head -20)
  cat <<EOF
{
  "additional_context": "Type check failed after your edit. Fix these errors before continuing:\n${errors}"
}
EOF
  exit 0
fi

echo '{ "additional_context": "Type check passed." }'
exit 0
