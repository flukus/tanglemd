#/usr/bin/env bash

dirname=$(dirname "${BASH_SOURCE[0]}")
cp "$dirname/source.sql" "$dirname/result.sql"
<"$dirname/source.md" ../untanglemd "$dirname/result.md"

diff "$dirname/result.sql" "$dirname/source.sql"
diff "$dirname/expected.md" "$dirname/result.md"

