#!/usr/bin/env bash
# ============================================================================
# One-shot deploy script for MONDSTATION HONECKER.
#
# Usage:
#   1. Create an empty repo on GitHub.com (e.g. "mondstation-honecker")
#   2. Set the env vars GH_USER and GH_REPO below (or pass them as arguments)
#   3. Run:  ./deploy.sh
#
# The script will:
#   - add the GitHub remote
#   - push the main branch
#   - tell you to enable Pages in repo Settings
# ============================================================================
set -e

GH_USER="${1:-${GH_USER:-YOUR_GITHUB_USERNAME}}"
GH_REPO="${2:-${GH_REPO:-mondstation-honecker}}"

if [ "$GH_USER" = "YOUR_GITHUB_USERNAME" ]; then
  cat <<EOF
Usage:
  ./deploy.sh <github-username> [repo-name]
or:
  GH_USER=<github-username> GH_REPO=<repo-name> ./deploy.sh

  1. Create an empty (no README) repo at:
       https://github.com/new   (name = mondstation-honecker)
  2. Run this script with your username.
  3. On github.com: Settings → Pages → Source: 'main' → Save.
EOF
  exit 1
fi

# add .nojekyll so GitHub Pages doesn't process index.html through Jekyll
[ -f .nojekyll ] || : > .nojekyll
git add .nojekyll
git diff --cached --quiet || git commit -m "chore: add .nojekyll for GitHub Pages"
git remote remove origin 2>/dev/null || true
git remote add origin "git@github.com:${GH_USER}/${GH_REPO}.git"
git branch -M main
git push -u origin main

cat <<EOF

✅ Pushed to git@github.com:${GH_USER}/${GH_REPO}.git

Last step: enable GitHub Pages
  → https://github.com/${GH_USER}/${GH_REPO}/settings/pages
  → Source: "Deploy from a branch" → "main" → / (root)
  → Save.

In ~30s the game will be live at:
  https://${GH_USER}.github.io/${GH_REPO}/
EOF
