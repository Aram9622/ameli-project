#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
command -v flutter >/dev/null || { echo 'Install Flutter and add its bin directory to PATH first.' >&2; exit 1; }
# Generates missing native runners; existing Dart sources are preserved.
flutter create --empty --platforms=android,ios --org dev.ameli --project-name ameli_mobile --no-pub .
flutter pub get
