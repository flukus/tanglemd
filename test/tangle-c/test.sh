#/usr/bin/env bash

dirname=$(dirname "${BASH_SOURCE[0]}")
echo "dirname: $dirname"
rm -f "$dirname/result.md"
../tanglemd "$dirname/source.md" > "$dirname/result.md"

diff "$dirname/expected.md" "$dirname/result.md"

