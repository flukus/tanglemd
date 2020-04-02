#/usr/bin/env bash

cp source.sql result.sql
cp source2.sql result2.sql

dirname=$(dirname "${BASH_SOURCE[0]}")
<"./source.md" ../../untangle.sh > "$dirname/result.md"

diff result.sql source.sql
diff result2.sql source2.sql
diff expected.md result.md

