#/usr/bin/env bash


dirname=$(dirname "${BASH_SOURCE[0]}")
cp "$dirname/source.sql" "$dirname/result.sql"
cp "$dirname/source2.sql" "$dirname/result2.sql"
<"$dirname/source.md" ../untanglemd "$dirname/result.md"

diff "$dirname/result.sql" "$dirname/source.sql"
diff "$dirname/result2.sql" "$dirname/source2.sql"
diff "$dirname/expected.md" "$dirname/result.md"

