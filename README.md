# twilight-shell/.github

What the repositories of the [twilight-shell](https://github.com/twilight-shell)
organization share: the checks run on every push and pull request, and the page
of the organization, `profile/README.md`, with the screenshots in
`profile/images/`, and the community files every repository inherits (the
contributing guide, the code of conduct, the security policy, the issue and pull
request templates).

## Using the checks

A component repository gets one file, `.github/workflows/ci.yml`:

```yaml
name: ci
on: [push, pull_request]
jobs:
  ci:
    uses: twilight-shell/.github/.github/workflows/module.yml@main
```

The shell repository calls `shell.yml` instead.

## What is checked

| | |
|---|---|
| Tests | Every `tests/*.qml`, run with Qt's `qml` tool. |
| Settings files | Every `<name>.defaults.toml` and `<name>.schema.toml` parses, and each option of a schema fits its defaults: the key is there, with a value of the type the option edits, a range's default is inside it and a choice's is one of the choices. |
| Dependencies | The `DEPENDS` of the repository says what its QML imports: every `import Twilight.X` of another module is listed, and everything listed is imported somewhere. |
| Install | `make install` into a scratch folder puts every file of the `qmldir` there, in a folder named after the module. |
| `qmllint` | Reports what it finds; it doesn't fail the run yet, since Quickshell's types can't be resolved in CI. |

The shell repository: `bin/twilight-shell` parses, `config init` makes a settings
file for every component, every submodule is at a commit on its repository's
`main`, and `make install` puts the launcher and the shell in place.

## Running the checks by hand

The scripts in `ci/` are what the workflows run, and need only Qt's `qml` tool:

```sh
export PATH=$PATH:/usr/lib/qt6/bin
ci/check-settings.sh path/to/bar path/to/core
ci/check-depends.sh path/to/bar
ci/check-install.sh path/to/bar
ci/run-tests.sh path/to/core
ci/check-shell.sh path/to/shell
```
