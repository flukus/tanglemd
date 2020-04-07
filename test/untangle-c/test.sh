#/usr/bin/env bash

cp source.c result.c

dirname=$(dirname "${BASH_SOURCE[0]}")
../../untangle.sh "./source.md" > "$dirname/result.md"

diff expected.c result.c
diff result.md expected.md

