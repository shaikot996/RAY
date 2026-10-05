#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST_BASE="${HOME}/.Wolfram/Applications"
DEST="${DEST_BASE}/RAY"

mkdir -p "${DEST_BASE}"
rm -rf "${DEST}"
cp -a "${SOURCE_DIR}" "${DEST}"

echo "RAY installed to:"
echo "  ${DEST}"
echo
echo 'Restart Mathematica and run:'
echo '  Needs["RAY`"]'
echo '  RAYHelp[]'
