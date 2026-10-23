#!/bin/sh
# Runs the tests of a module: every tests/*.qml, with Qt's `qml` tool. A test
# prints its result and exits with a non-zero code when a check fails.
#
#     run-tests.sh <module-dir>
set -e

module=$(cd "$1" && pwd)
cd "$module"
ls tests/*.qml > /dev/null 2>&1 || { echo "no tests"; exit 0; }

bad=0
for test in tests/*.qml; do
    echo "== $test"
    QT_QPA_PLATFORM=offscreen timeout 120 qml "$test" || bad=1
done
exit $bad
