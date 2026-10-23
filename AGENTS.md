# AGENTS.md

For AI coding agents working in this repository; humans may find it a quick orientation.
The guide for everyone is [CONTRIBUTING.md](CONTRIBUTING.md).

## What this is

The `.github` repository of the [twilight-shell](https://github.com/twilight-shell)
organization. It has three kinds of things, none of them shell code:

- `ci/`: the scripts the checks of every repository run (`check-settings.sh`,
  `check-depends.sh`, `check-install.sh`, `check-shell.sh`, `run-tests.sh`).
- `.github/workflows/`: the reusable workflows (`module.yml`, `shell.yml`) that each
  repository calls from its own `ci.yml`.
- The community files that GitHub applies to every repository of the organization that
  has none of its own: `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`,
  `SUPPORT.md`, `ISSUE_TEMPLATE/`, `PULL_REQUEST_TEMPLATE.md`; and `profile/`, the page
  of the organization with its screenshots.

## Check your work

The scripts need only `sh` and Qt's `qml` tool (put `/usr/lib/qt6/bin` on the path).
Run them on the repositories next to this one:

```sh
ci/check-settings.sh ../bar ../core
ci/check-depends.sh ../bar
ci/check-install.sh ../bar
ci/run-tests.sh ../core
ci/check-shell.sh ../shell
```

Each prints `ok ...` or `FAIL ...` and exits non-zero on a failure. **A check that can't
fail is worth nothing:** when you add or change one, break a copy of a repository on
purpose and see that it goes red. The workflows themselves only run on GitHub, so read
them twice.

## Rules

- Work on a branch (`feat/...`, `fix/...`, `docs/...`); never commit to or push `main`.
  Changes land through a pull request.
- Commit messages are `type: Subject` (`feat`, `fix`, `docs`, `test`, `ci`, `chore`),
  imperative, capitalized, no full stop.
- **Everything here reaches every repository.** A check that is too strict turns the CI of
  all of them red at once; merge a new check only after the repositories it needs
  (a new file, say) have it.
- Images in `profile/` are linked by their address on `raw.githubusercontent.com`, which
  works on the organization's page. A screenshot of a whole screen shows whatever is
  open on it: take it on an empty workspace, and don't publish what isn't yours.
- The community files speak for the project. Don't put a person's private contact in
  them without their say; use GitHub's private reporting or a contact they gave.

## Gotchas

- A script that is run with `sh` must work in dash: no `[[ ]]`, no `${x//a/b}`.
- A reusable workflow is called by the `main` of this repository: until a change is
  merged here, it has no effect on the others.
