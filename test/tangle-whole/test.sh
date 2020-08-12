#/usr/bin/env sh

testname='tangle-whole'
result="$PWD/test/$testname/result.md"

rm -f "$result"
$srcdir/tanglemd "$srcdir/test/$testname/source.md" > "$result"

diff "$srcdir/test/$testname/expected.md" "$result"

