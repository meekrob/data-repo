#!/usr/bin/env bash
set -euo pipefail

# location of script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATADIR="${SCRIPT_DIR}/../datadir.sh"

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

# make dummy input files
echo "foo" > "$tmpdir/file1.txt"
echo "bar" > "$tmpdir/file2.txt"

cd "$tmpdir"

# Run the script
"$DATADIR" file1.txt file2.txt

# Check output
dest=$(ls -d file1-* | head -n1)
if [[ -d "$dest" && -f "$dest/file1.txt" && -f "$dest/file2.txt" ]]; then
    echo "test_basic.sh: PASS"
else
    echo "test_basic.sh: FAIL"
    exit 1
fi

