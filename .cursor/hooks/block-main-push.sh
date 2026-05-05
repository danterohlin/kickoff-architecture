#!/bin/bash
input=$(cat)
command_str=$(echo "$input" | jq -r '.command // empty')

if echo "$command_str" | grep -qE 'git push.*(origin\s+main|origin/main|--all)'; then
  echo '{
    "permission": "deny",
    "user_message": "Blocked: pushing directly to main. Use a feature branch and create a PR.",
    "agent_message": "You attempted to push to main. This is blocked because main auto-deploys to production. Work on a feature branch (git checkout -b T-{task-id}) and push there instead."
  }'
  exit 0
fi

echo '{ "permission": "allow" }'
exit 0
