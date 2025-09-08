#!/usr/bin/env bash
# Template for testing datadir.sh with filelist.txt verification
set -euo pipefail

# ===== Configuration =====
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATADIR="${SCRIPT_DIR}/../datadir.sh"

# Temporary directory for isolation
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

# Input files for this test
cd "$tmpdir"
echo "dummy1" > file1.txt
echo "dummy2" > file2.txt

# Script arguments for this test
# Modify as needed, e.g. "--name testproj --move-method cp"
ARGS="file1.txt file2.txt"

# Expected behavior
EXPECTED_PREFIX="file1"          # Used to detect destination directory
EXPECTED_FILES=("file1.txt" "file2.txt")
ORIGINAL_SHOULD_EXIST=true

# ===== Run Script =====
"$DATADIR" $ARGS

# ===== Verify Results =====
destdir=$(ls -d ${EXPECTED_PREFIX}-* | head -n1)

# Check destination exists
if [[ ! -d "$destdir" ]]; then
    echo "FAIL: destination directory $destdir not found"
    exit 1
fi

# Check files in destination
for f in "${EXPECTED_FILES[@]}"; do
    if [[ ! -f "$destdir/$f" ]]; then
        echo "FAIL: $f not found in $destdir"
        exit 1
    fi
done

# Check if original files exist or not
for f in "${EXPECTED_FILES[@]}"; do
    if $ORIGINAL_SHOULD_EXIST && [[ ! -f "$f" ]]; then
        echo "FAIL: original file $f missing"
        exit 1
    elif ! $ORIGINAL_SHOULD_EXIST && [[ -f "$f" ]]; then
        echo "FAIL: original file $f s

