#!/usr/bin/env bash
set -euo pipefail

ACTION=${1:-apk}

case "${ACTION}" in
  apk)
    echo "→ Building release APK..."
    flutter build apk --release
    cp build/app/outputs/flutter-apk/app-release.apk "pcalc-v$(git describe --tags --always 2>/dev/null || echo 0).apk"
    echo "✓ APK generated"
    ;;
  install)
    echo "→ Building and installing on connected device..."
    flutter build apk --release
    flutter install
    echo "✓ Installed on device"
    ;;
  linux)
    echo "→ Building Linux binary..."
    flutter build linux --release
    echo "✓ Linux build at build/linux/x64/release/bundle/"
    ;;
  *)
    echo "Usage: $0 {apk|install|linux}"
    exit 1
    ;;
esac
