#!/bin/sh
# Installs a module into a scratch directory and checks it: every file its
# qmldir lists is there, and the module is named after the folder it landed in.
#
#     check-install.sh <module-dir>
set -e

module=$(cd "$1" && pwd)
[ -f "$module/Makefile" ] || { echo "no Makefile, nothing to install"; exit 0; }

dest=$(mktemp -d)
trap 'rm -rf "$dest"' EXIT
make -C "$module" install DESTDIR="$dest" PREFIX=/usr > /dev/null

bad=0
found=0
for qmldir in $(find "$dest" -name qmldir); do
    found=$((found + 1))
    dir=$(dirname "$qmldir")
    # .../Twilight/Bar must declare `module Twilight.Bar`.
    want="$(basename "$(dirname "$dir")").$(basename "$dir")"
    have=$(sed -n 's/^module[[:space:]]\+//p' "$qmldir")
    if [ "$have" != "$want" ]; then
        echo "FAIL $qmldir: declares '$have', installed as '$want'"
        bad=1
    fi
    # `Name 1.0 file.qml`, `singleton Name 1.0 file.qml`: the file is the last word.
    grep -v -e '^module' -e '^[[:space:]]*#' -e '^[[:space:]]*$' "$qmldir" | while read -r line; do
        file=${line##* }
        [ -f "$dir/$file" ] || { echo "FAIL $qmldir: lists $file, which wasn't installed"; exit 1; }
    done || bad=1
    echo "ok $want"
done

if [ "$found" -eq 0 ]; then
    echo "FAIL: make install put no qmldir anywhere"
    exit 1
fi
exit $bad
