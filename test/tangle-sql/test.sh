#/usr/bin/env bash

dirname=$(dirname "${BASH_SOURCE[0]}")
<"$dirname/source.md" ../../tangle.sh > "$dirname/result.md"

diff expected.md result.md

