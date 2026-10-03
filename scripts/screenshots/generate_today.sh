#!/usr/bin/env bash
# Usage: ./scripts/screenshots/generate_today.sh [phone|tablet_7|tablet_10|all] [locale]
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$DIR/generate_overview.sh" "${1:-phone}" "${2:-}"
