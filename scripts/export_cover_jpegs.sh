#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
INPUT_PDF="${REPO_ROOT}/meta/nado-cover-rgb.pdf"
META_DIR="${REPO_ROOT}/meta"
DOCS_DIR="${REPO_ROOT}/docs"

if ! command -v magick >/dev/null 2>&1; then
    echo "magick is required. Install ImageMagick with: brew install imagemagick" >&2
    exit 1
fi

if [ ! -f "${INPUT_PDF}" ]; then
    echo "Cover PDF not found: ${INPUT_PDF}" >&2
    echo "Export it first with Scribus before generating JPEG previews." >&2
    exit 1
fi

TMP_DIR="$(mktemp -d)"
cleanup() {
    rm -rf "${TMP_DIR}"
}
trap cleanup EXIT

magick -density 180 \
    -define pdf:use-trimbox=true \
    "${INPUT_PDF}[0]" \
    -crop 52.25x100% +repage \
    \( -clone 0 -crop 92x100% +repage -reverse \) \
    -delete 0 \
    -reverse \
    "${TMP_DIR}/slice.jpg"

mv "${TMP_DIR}/slice-2.jpg" "${META_DIR}/front.jpg"
mv "${TMP_DIR}/slice-0.jpg" "${META_DIR}/back.jpg"
mv "${TMP_DIR}/slice-1.jpg" "${META_DIR}/spine.jpg"
cp "${META_DIR}/front.jpg" "${DOCS_DIR}/front.jpg"

echo "Updated meta/front.jpg, meta/back.jpg, meta/spine.jpg, and docs/front.jpg"
