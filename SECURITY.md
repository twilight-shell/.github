# Security

## Reporting a vulnerability

**Please don't open a public issue for a security problem.** Report it privately:

- on the repository it is in: the **Security** tab, then **Report a vulnerability**
  (GitHub's private reporting), or
- on Telegram, to [@meidorislav](https://t.me/meidorislav).

Say what you found, which repository and version (`git describe --tags` in a clone, or
the release), and how to reproduce it. We read every report, aim to answer within a
week, and will tell you when it is fixed and, if you like, thank you by name.

## What counts

The parts of the shell that deserve the most care:

- **The lock screen** ([lock](https://github.com/twilight-shell/lock)): anything that
  lets someone get past it without the password, keeps the session from locking, or
  leaves the password where it can be read.
- **Plugins** ([plugins](https://github.com/twilight-shell/plugins)): anything that
  runs a plugin that wasn't switched on, or runs one with more than the rights of the
  user, or makes a plugin run by a file the user didn't put in a plugins folder.
- **The notification daemon and the IPC** of the components: anything that lets another
  program or user do what only the user should be able to.
- **Files the shell reads and writes** (`~/.config/twilight-shell/`, the plugin
  folders): a path or a value that makes it read or write somewhere it shouldn't.

## What doesn't

- **A plugin that does what it says.** A plugin is code that runs with the rights of the
  user who switched it on; there is no sandbox, and the settings window says so. A
  malicious plugin that the user chose to enable is the user's call, not a flaw here.
  A plugin that gets around the switch is, see above.
- Problems in Quickshell, Qt, the compositor or PAM themselves: please report those to
  their projects.

## Supported versions

Only the latest release of each repository gets fixes. Until 1.0, that is the latest
`0.x`.
