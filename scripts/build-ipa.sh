#!/usr/bin/env bash
# Builds Helios.ipa on a Mac. Requirements: macOS, Xcode, Rust, Node.js 20+.
# Set APPLE_DEVELOPMENT_TEAM to your 10-character Apple Team ID before running.
set -euo pipefail
cd "$(dirname "$0")/.."

if [[ "$(uname)" != "Darwin" ]]; then
  echo "Error: iOS apps can only be compiled on macOS with Xcode." >&2
  exit 1
fi
: "${APPLE_DEVELOPMENT_TEAM:?Set APPLE_DEVELOPMENT_TEAM to your Apple Team ID}"

EXPORT_METHOD="${1:-release-testing}"   # release-testing | app-store-connect | debugging

rustup target add aarch64-apple-ios
npm install
npx tauri icon app-icon.svg
[[ -d src-tauri/gen/apple ]] || npx tauri ios init
npx tauri ios build --export-method "$EXPORT_METHOD"

echo
echo "Done. Your .ipa:"
find src-tauri/gen/apple/build -name '*.ipa' -print
