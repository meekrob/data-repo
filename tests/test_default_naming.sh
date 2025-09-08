#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATADIR="${SCRIPT_DIR}/../datadir.sh"

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

# Create dummy input files
echo "foo" > "$tmpdir/file1.txt"
echo "bar" > "$tmpdir/file2.txt"

cd "$tmpdir"

# Run the script
"$DATADIR" file1.txt file2.txt

# Find the created directory (should start with file1-)
destdir=$(ls -d file1-* | head -n1)

if [[ -d "$destdir" && -f "$destdir/file1.txt" && -f "$destdir/file2.txt" ]]; then
    echo "test_default_naming.sh: PASS"
else
    echo "test_default_naming.sh: FAIL"
    exit 1
fi

