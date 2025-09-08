#!/usr/bin/env bash
set -euo pipefail

for t in tests/test_*.sh; do
    bash "$t"
done

echo "All tests passed!"

