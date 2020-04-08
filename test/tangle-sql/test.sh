#/usr/bin/env bash

dirname=$(dirname "${BASH_SOURCE[0]}")
rm "$dirname/result.md"
../tanglemd "$dirname/source.md" > "$dirname/result.md"

diff "$dirname/expected.md" "$dirname/result.md"

