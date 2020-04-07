#/usr/bin/env bash

rm result.md
dirname=$(dirname "${BASH_SOURCE[0]}")
../../tangle.sh "$dirname/source.md" > "$dirname/result.md"

diff expected.md result.md

