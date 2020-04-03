#/usr/bin/env bash

rm result.md
dirname=$(dirname "${BASH_SOURCE[0]}")
<"$dirname/source.md" ../../tangle.sh > "$dirname/result.md"

diff expected.md result.md

