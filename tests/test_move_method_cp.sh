#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATADIR="${SCRIPT_DIR}/../datadir.sh"

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

# Create dummy input file
echo "baz" > "$tmpdir/fileA.txt"

cd "$tmpdir"

# Run with copy method
"$DATADIR" --move-method cp fileA.txt

# Find the created directory (should start with fileA-)
destdir=$(ls -d fileA-* | head -n1)

if [[ -d "$destdir" && -f "$destdir/fileA.txt" && -f "fileA.txt" ]]; then
    echo "test_move_method_cp.sh: PASS"
else
    echo "test_move_method_cp.sh: FAIL"
    exit 1
fi

