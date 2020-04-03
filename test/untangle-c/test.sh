#/usr/bin/env bash

cp source.c result.c

dirname=$(dirname "${BASH_SOURCE[0]}")
<"./source.md" ../../untangle.sh > "$dirname/result.md"

diff expected.c result.c
diff result.md expected.md

