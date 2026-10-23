#!/bin/sh
# Checks that the DEPENDS of a repository says what its QML imports: every
# `import Twilight.X` of another module is listed, and everything listed is
# imported somewhere. A `?` before a name marks a module that is only nice to have.
#
#     check-depends.sh <module-dir>
set -e

module=$(cd "$1" && pwd)

# The modules this repository is itself: the folders in Twilight/.
own=$(ls "$module/Twilight" 2>/dev/null || true)

imported=$(find "$module" -name '*.qml' -not -path '*/.git/*' -exec sed -n 's/^import Twilight\.\([A-Za-z]*\).*/\1/p' {} + | sort -u)
imported=$(for m in $imported; do echo "$own" | grep -qx "$m" || echo "$m"; done)

listed=""
if [ -f "$module/DEPENDS" ]; then
    listed=$(sed 's/#.*//' "$module/DEPENDS" | tr -s ' \t\n' '\n' | sed 's/^?//' | grep -v '^$' | sort -u)
fi

bad=0
for m in $imported; do
    if ! echo "$listed" | grep -qx "$m"; then
        echo "FAIL: imports Twilight.$m, which DEPENDS doesn't list"
        bad=1
    fi
done
for m in $listed; do
    if ! echo "$imported" | grep -qx "$m"; then
        echo "FAIL: DEPENDS lists $m, which nothing imports"
        bad=1
    fi
done

if [ "$bad" -eq 0 ]; then
    echo "ok depends: $(echo $listed | sed 's/ /, /g' | sed 's/^$/nothing/')"
fi
exit $bad
