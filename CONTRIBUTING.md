# Contributing to twilight-shell

Thank you for wanting to help. This is the guide for every repository of the
[twilight-shell](https://github.com/twilight-shell) organization; a repository's own
`CONTRIBUTING.md` says what is particular to it.

There is a lot to do besides code: report a bug, describe what you wanted that the
shell doesn't do, improve a README, or write a [plugin](https://github.com/twilight-shell/plugins)
and share it. Please be kind: the [Code of Conduct](CODE_OF_CONDUCT.md) applies
everywhere here. Security problems are reported privately, see [SECURITY.md](SECURITY.md).

## How the project is laid out

Every component is a repository of its own that works on its own and installs on its
own. [shell](https://github.com/twilight-shell/shell) puts them together, with the
components as git submodules at the commits that were tested together. The components
need as little of each other as they can: what one needs is in its `DEPENDS` file,
and almost every one needs only [core](https://github.com/twilight-shell/core) (the
theme and the sticker UI kit).

A few rules the code follows, and a change should keep following:

- **A component doesn't know the others.** What it needs from outside comes in as
  properties (an output name, what is open elsewhere) and what it wants done goes
  out as signals. The shell is where components are connected, not the components.
- **Defaults live in one place:** `<name>.defaults.toml` next to the component. The
  settings file the user edits is made from it. A default is never repeated in code.
- **A setting is described, not hard-wired.** A `<name>.schema.toml` next to the
  defaults gives the component a page in the settings window with no change to
  `settings`.
- **Nothing is tied to one compositor.** Anything that asks the compositor goes
  through the `compositor` module.
- **Logic that can be pure is pure:** a `.pragma library` JavaScript file with tests,
  not a block inside a QML file.

## Getting set up

You need [Quickshell](https://quickshell.org) 0.3 or newer and Qt's `qml` tool.

To work on the whole shell:

```sh
git clone --recurse-submodules git@github.com:twilight-shell/shell.git
cd shell
bin/twilight-shell
```

To work on one component, clone it and the modules it needs (its `DEPENDS`), and point
`QML_IMPORT_PATH` at their parent folders, with full paths separated by `:`:

```sh
QML_IMPORT_PATH=$HOME/src/core:$HOME/src/compositor qs -p $HOME/src/bar
```

**Try things with a settings folder of their own,** so your real settings stay as
they are:

```sh
XDG_CONFIG_HOME=$(mktemp -d) QML_IMPORT_PATH=... qs -p .
```

Two things to know when the shell is running. Quickshell loads again when a QML file
of the config changes, but the list of modules is read once, at start: a new module
needs a restart. And never test the lock screen for real without a way out. Try it
with `twilight-shell lock preview`, and if you have to lock for real, have a TTY to
switch to (Ctrl+Alt+F2) and a timer that unlocks by itself.

## Making a change

1. **Talk first for anything big.** Open an issue and say what you want to do. For a
   small fix, just send it.
2. **Branch from `main`:** `feat/short-name`, `fix/short-name`, `docs/...`. Never
   push to `main`; changes land through a pull request.
3. **Keep a pull request to one thing,** and small. Several small ones are easier to
   review than one big one.
4. **Write the commit message** as `type: Subject`, with the type one of `feat`,
   `fix`, `docs`, `test`, `ci`, `chore` or `refactor`, and the subject in the
   imperative, starting with a capital and with no full stop: `fix: Show the 12-hour
   clock in 12 hours`. Say why in the body when it isn't obvious.
5. **Test what you changed.** Logic that is pure gets a test in `tests/`. Anything
   with a screen: run it and look. Say in the pull request what you tried and on
   which compositor.
6. **Update what the change touches:** the `CHANGELOG.md` (a line under `## Unreleased`
   at the top, make the heading if there is none), the README, the defaults and the
   schema of a setting, the `DEPENDS` if the component now imports another module.

Run the checks that CI runs, from a clone of
[.github](https://github.com/twilight-shell/.github), with Qt's `qml` tool on your
path (`/usr/lib/qt6/bin` on most systems):

```sh
ci/run-tests.sh path/to/component
ci/check-settings.sh path/to/component path/to/core
ci/check-depends.sh path/to/component
ci/check-install.sh path/to/component
```

## Code style

- QML in the style of the code around it: four spaces, properties first and then
  functions, then children, a blank line between them, `id` first in an object.
- Comments say **why**, not what the next line does. English, short.
- Names say what a thing is: `outputName`, `launcherOpen`, not `x2` or `flag`.
- Small files. A file that grows past a few hundred lines wants to be split into
  parts with names of their own, as `bar` and `lock` are.
- No new dependency (a library, a program that has to be installed) without
  talking about it first.

## Releases

Maintainers do this. Each repository is versioned on its own with
[Semantic Versioning](https://semver.org); until 1.0 a minor version may change how
things work. For a release: move the lines under `## Unreleased` in `CHANGELOG.md` to
a heading with the version and the date, merge, tag the merge commit `vX.Y.Z` (an
annotated tag), and make a release on GitHub from the tag with the text of that
section. The shell is released last: its submodules are moved to the new tags first,
and that pull request is tagged.

## Using tools to write code

Use whatever helps you, an assistant included. You are the author of what you send:
read it, run it, and be able to explain it. Agents working in a repository should read
its `AGENTS.md`.

## License

The code is MIT (see `LICENSE` in each repository). By sending a change you agree that
it is shared under that license. The mascot's sprites are not part of the code; they
keep their own license, see the [mascot](https://github.com/twilight-shell/mascot) README.
