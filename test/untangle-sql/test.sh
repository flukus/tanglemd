#/usr/bin/env bash

cp source.sql result.sql

dirname=$(dirname "${BASH_SOURCE[0]}")
<"./source.md" ../../untangle.sh > "$dirname/result.md"

diff result.sql source.sql
diff expected.md result.md

