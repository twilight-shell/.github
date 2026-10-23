<h1 align="center">twilight-shell</h1>

<p align="center">
A desktop shell for Wayland, made of pieces that each live in their own repository and install on their own.<br>
Built with <a href="https://quickshell.org">Quickshell</a>, painted like a night sky over Ponyville.
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/twilight-shell/.github/main/profile/images/overview.png" alt="The shell: live star wallpaper, the bar, the volume pop-up and Twilight the mascot" width="100%">
</p>

## What it is

A bar, a launcher, notifications, a lock screen, a wallpaper, a mascot, a settings
window and plugins, all drawn in one sticker style that follows a single palette.
Nothing is tied to the rest: want only the launcher? Install only the launcher.
Don't like the bar? Leave it out. Want something that isn't here? Write a plugin.

It runs on [niri](https://github.com/YaLTeR/niri) today. Everything that talks to
the compositor goes through one small module, so other Wayland compositors can
follow.

## The pieces

### [bar](https://github.com/twilight-shell/bar)

Floating islands along the top of every screen: the launcher button, the
workspaces, the focused window, a clock, the keyboard layout, the tray and the
volume. Plugins can add islands of their own.

<img src="https://raw.githubusercontent.com/twilight-shell/.github/main/profile/images/bar.png" alt="The bar" width="100%">

### [app-launcher](https://github.com/twilight-shell/app-launcher)

"Twilight's Library": a spellbook card over a night sky. Type to search, and it
still finds Firefox when you typed it on the wrong keyboard layout.

<img src="https://raw.githubusercontent.com/twilight-shell/.github/main/profile/images/launcher.png" alt="The launcher" width="100%">

### [popouts](https://github.com/twilight-shell/popouts)

Cards that drop out of the bar: a calendar with the phase of the moon under the
clock, and a sound mixer under the volume.

<img src="https://raw.githubusercontent.com/twilight-shell/.github/main/profile/images/calendar.png" alt="The calendar" height="440"> <img src="https://raw.githubusercontent.com/twilight-shell/.github/main/profile/images/sound.png" alt="The sound mixer" height="440">

### [notifications](https://github.com/twilight-shell/notifications) and [osd](https://github.com/twilight-shell/osd)

The notification daemon, with actions, a fuse that burns down while a card is on
screen, and cards that make way for the popouts. And the pop-up that rises from the
bottom edge when the volume changes.

<img src="https://raw.githubusercontent.com/twilight-shell/.github/main/profile/images/notification.png" alt="A notification" width="440"> <img src="https://raw.githubusercontent.com/twilight-shell/.github/main/profile/images/osd.png" alt="The volume pop-up" width="300">

### [lock](https://github.com/twilight-shell/lock)

The lock screen, a process of its own that exists only while the session is
locked: the password goes through PAM, the keyboard layout is shown so you don't
type it in the wrong one, and a wrong password shakes the card.

<img src="https://raw.githubusercontent.com/twilight-shell/.github/main/profile/images/lock.png" alt="The lock screen" width="760">

### [wallpaper](https://github.com/twilight-shell/wallpaper)

A picture that is revealed through a growing circle when it changes, or an LED
wall of drifting, twinkling stars in the palette's colors (the one behind
everything on this page).

### [mascot](https://github.com/twilight-shell/mascot)

Twilight lives in a corner of the screen. She strolls along the bottom edge, talks
in a bubble, dances when music plays, dozes off late at night and can be picked up
and thrown. Her sprites are not part of the repository: the repository has a
script that fetches them, with the credits.

<img src="https://raw.githubusercontent.com/twilight-shell/.github/main/profile/images/mascot.png" alt="Twilight the mascot" width="200">

## Settings

Every component keeps its settings in a TOML file of its own in
`~/.config/twilight-shell/`, made from its defaults the first time it runs.
Edit the file and it applies at once, or use the settings window, which builds a
page for every component that describes its settings: there is nothing to
register, and a plugin gets its page the same way.

<img src="https://raw.githubusercontent.com/twilight-shell/.github/main/profile/images/settings-appearance.png" alt="The settings window: palettes" width="49%"> <img src="https://raw.githubusercontent.com/twilight-shell/.github/main/profile/images/settings-wallpaper.png" alt="The settings window: wallpaper" width="49%">

Choose a palette, or make one of your own, or take the colors from the wallpaper.

<img src="https://raw.githubusercontent.com/twilight-shell/.github/main/profile/images/settings-bar.png" alt="The settings window: the bar" width="49%"> <img src="https://raw.githubusercontent.com/twilight-shell/.github/main/profile/images/settings-mascot.png" alt="The settings window: the mascot" width="49%">

## Installing

Everything, with the shell that puts it together ([shell](https://github.com/twilight-shell/shell)):

```sh
git clone --recurse-submodules git@github.com:twilight-shell/shell.git
cd shell
sudo make install
```

Or only what you want. What a component needs comes with it:

```sh
sudo make install ONLY="bar"                  # the bar, with core and compositor
sudo make install ONLY="app-launcher lock"    # two, with core
```

A component needs the [core](https://github.com/twilight-shell/core) (the theme and
the sticker kit); the bar also needs the
[compositor](https://github.com/twilight-shell/compositor) module, and the lock
screen can use it.

## Plugins

A plugin is a folder with a `plugin.toml` and some QML. It can draw windows,
answer IPC calls, put an island in the bar and have a page in the settings window.
Nothing runs until you switch it on. Start from the
[plugin-template](https://github.com/twilight-shell/plugin-template), and read how
it all works in [plugins](https://github.com/twilight-shell/plugins).

<img src="https://raw.githubusercontent.com/twilight-shell/.github/main/profile/images/settings-plugins.png" alt="The plugins page of the settings window" width="640">

## The repositories

| | |
|---|---|
| [shell](https://github.com/twilight-shell/shell) | Puts the components together; installs the whole thing or a part of it. |
| [core](https://github.com/twilight-shell/core) | The theme, the palettes, the sticker UI kit, settings files. |
| [compositor](https://github.com/twilight-shell/compositor) | Workspaces, the focused window, the keyboard layout, the same for every compositor (niri so far). |
| [bar](https://github.com/twilight-shell/bar), [app-launcher](https://github.com/twilight-shell/app-launcher), [popouts](https://github.com/twilight-shell/popouts), [notifications](https://github.com/twilight-shell/notifications), [osd](https://github.com/twilight-shell/osd), [lock](https://github.com/twilight-shell/lock), [wallpaper](https://github.com/twilight-shell/wallpaper), [mascot](https://github.com/twilight-shell/mascot) | The components. |
| [settings](https://github.com/twilight-shell/settings) | The settings window. |
| [plugins](https://github.com/twilight-shell/plugins), [plugin-template](https://github.com/twilight-shell/plugin-template) | The plugin loader, and a plugin to start from. |
| [.github](https://github.com/twilight-shell/.github) | This page, and the checks that run on every push. |

## Credits

The mascot's sprites are the work of the artists behind
[Desktop Ponies](https://github.com/RoosterDragon/Desktop-Ponies), shared under
CC BY-NC-SA 3.0. My Little Pony: Friendship is Magic is © Hasbro; this project
isn't affiliated with or endorsed by Hasbro or Desktop Ponies. The font is
[Monocraft](https://github.com/IdreesInc/Monocraft).
