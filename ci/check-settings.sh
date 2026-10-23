#!/bin/sh
# Checks the settings files of a module: every <name>.defaults.toml and
# <name>.schema.toml parses, and each option of a schema fits the defaults
# (the key is there, with a value of the type the option edits).
#
#     check-settings.sh <module-dir> <core-dir>
#
# Needs Qt's `qml` tool and the core module, for its TOML parser.
set -e

module=$(cd "$1" && pwd)
core=$(cd "$2" && pwd)
toml="$core/Twilight/Core/util/Toml.js"
[ -f "$toml" ] || { echo "no Toml.js in $core"; exit 1; }

# One entry per settings file: its base path and whether it has a schema.
entries=$(find "$module" \( -name '*.defaults.toml' -o -name '*.schema.toml' \) -not -path '*/.git/*' \
    | sed -E 's/\.(defaults|schema)\.toml$//' | sort -u \
    | while read -r base; do
        d=false; s=false
        [ -f "$base.defaults.toml" ] && d=true
        [ -f "$base.schema.toml" ] && s=true
        printf '{ base: "%s", defaults: %s, schema: %s },\n' "$base" "$d" "$s"
    done)

if [ -z "$entries" ]; then
    echo "no settings files, nothing to check"
    exit 0
fi

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

cat > "$work/check.qml" <<QML
import QtQuick
import "$toml" as Toml

Item {
    Component.onCompleted: {
        let bad = 0;
        const read = path => {
            const x = new XMLHttpRequest();
            x.open("GET", "file://" + path, false);
            x.send();
            return x.responseText;
        };
        const kinds = ["toggle", "range", "choice", "text", "command"];
        const entries = [
$entries
        ];

        for (const entry of entries) {
            const name = entry.base.slice(entry.base.lastIndexOf("/") + 1);
            const before = bad;
            const fail = message => { bad++; console.log("FAIL", name + ":", message); };
            let defaults = null;
            let schema = null;

            try {
                if (entry.defaults)
                    defaults = Toml.parse(read(entry.base + ".defaults.toml"));
            } catch (e) {
                fail("defaults: " + e.message);
            }
            try {
                if (entry.schema)
                    schema = Toml.parse(read(entry.base + ".schema.toml"));
            } catch (e) {
                fail("schema: " + e.message);
            }
            if (schema && !entry.defaults)
                fail("a schema needs a defaults file next to it");
            if (!schema || !defaults) {
                if (defaults && bad === before)
                    console.log("ok", name, "defaults");
                continue;
            }

            if (!schema.title)
                fail("no title");
            for (const option of schema.options ?? []) {
                const id = option.key ?? "?";
                if (!option.key || !option.title) {
                    fail(id + ": needs a key and a title");
                    continue;
                }
                if (!kinds.includes(option.type)) {
                    fail(id + ": unknown type '" + option.type + "'");
                    continue;
                }
                let value = defaults;
                for (const part of String(option.key).split("."))
                    value = value?.[part];
                if (value === undefined) {
                    fail(id + ": not in the defaults");
                    continue;
                }
                if (option.type === "toggle" && typeof value !== "boolean")
                    fail(id + ": a toggle needs a boolean default");
                if (option.type === "text" && typeof value !== "string")
                    fail(id + ": a text needs a string default");
                if (option.type === "command" && !Array.isArray(value))
                    fail(id + ": a command needs a list default");
                if (option.type === "range") {
                    if (typeof value !== "number" || typeof option.from !== "number" || typeof option.to !== "number")
                        fail(id + ": a range needs numbers: from, to and the default");
                    else if (option.from >= option.to || value < option.from || value > option.to)
                        fail(id + ": the default " + value + " is outside " + option.from + ".." + option.to);
                }
                if (option.type === "choice" && !(option.choices ?? []).some(c => JSON.stringify(c.value) === JSON.stringify(value)))
                    fail(id + ": the default " + JSON.stringify(value) + " is not among the choices");
            }
            if (bad === before)
                console.log("ok", name, (schema.options ?? []).length, "options");
        }
        Qt.exit(bad ? 1 : 0);
    }
}
QML

QML_XHR_ALLOW_FILE_READ=1 QT_QPA_PLATFORM=offscreen timeout 60 qml "$work/check.qml"
