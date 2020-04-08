#/usr/bin/env bash


dirname=$(dirname "${BASH_SOURCE[0]}")
cp "$dirname/source.c" "$dirname/result.c"
<"$dirname/source.md" ../untanglemd "$dirname/result.md"

diff "$dirname/expected.c" "$dirname/result.c"
diff "$dirname/result.md" "$dirname/expected.md"

