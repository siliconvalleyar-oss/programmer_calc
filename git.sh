#!/usr/bin/env bash
set -euo pipefail

VERSION=${1:-$(date +%Y%m%d.%H%M)}
REMOTE=${2:-origin}
BRANCH=${3:-main}

git add -A

git commit -m "pcalc: release ${VERSION}"

git tag -a "v${VERSION}" -m "Release ${VERSION}"

git push "${REMOTE}" "${BRANCH}" --tags

echo "✓ Released v${VERSION} to ${REMOTE}/${BRANCH}"
