#!/usr/bin/env bash
# Commit staged changes, push, and trigger the Ghost Frog demo workflow.
set -euo pipefail

REPO="bhanurp/CefSharp.MinimalExample"
WORKFLOW="ghostfrog.yml"
BRANCH="$(git rev-parse --abbrev-ref HEAD)"

if [ -z "$(git status --porcelain)" ]; then
  echo "Nothing to commit."
else
  MESSAGE="${1:?Usage: $0 \"commit message\"}"
  git add -A
  git commit -m "$MESSAGE"
  git push origin "$BRANCH"
fi

RUN_URL="$(gh workflow run "$WORKFLOW" --repo "$REPO" 2>&1)"
echo "Triggered: $RUN_URL"

RUN_ID="$(gh run list --repo "$REPO" --workflow "$WORKFLOW" --limit 1 --json databaseId --jq '.[0].databaseId')"
gh run watch "$RUN_ID" --repo "$REPO"
