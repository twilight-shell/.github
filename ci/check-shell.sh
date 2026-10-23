#!/bin/sh
# Checks the shell repository, checked out with its submodules:
# the launcher script is valid, `config init` creates a settings file for every
# component, and every submodule is at a commit that is on its repo's main.
#
#     check-shell.sh <shell-dir>
set -e

shell=$(cd "$1" && pwd)
cd "$shell"

sh -n bin/twilight-shell
echo "ok bin/twilight-shell parses"

config=$(mktemp -d)
trap 'rm -rf "$config"' EXIT
XDG_CONFIG_HOME="$config" bin/twilight-shell config init > /dev/null
count=$(ls "$config/twilight-shell" | wc -l)
want=$(find modules -name '*.defaults.toml' | wc -l)
if [ "$count" -ne "$want" ]; then
    echo "FAIL: config init made $count files for $want defaults files"
    exit 1
fi
echo "ok config init made $count settings files"

bad=0
for module in modules/*; do
    git -C "$module" fetch -q --unshallow origin main 2>/dev/null || git -C "$module" fetch -q origin main
    if git -C "$module" merge-base --is-ancestor HEAD FETCH_HEAD; then
        echo "ok $module is on main"
    else
        echo "FAIL $module is at a commit that isn't on its main"
        bad=1
    fi
done
exit $bad
