# :carrot: Carrot awesomeWM personalization application
* Do you want to have a __light__ and __geeky__ desktop environment, full of tiny widgets, on your linux?
* Have you ever wondered if you could configure [awesomeWM][awesomewm]
without learning [lua][lua]
and reading [awful][awful] documents?

__Thanks God__, for creating :carrot:

# Contents
* [Features](#features)
* [Installation](#installation)
    * [Prerequisites](#prerequisites)
    * [AUR (Arch User Repository)](#aur-arch-user-repository)
    * [luarocks](#luarocks)
    * [git](#git)
* [Usage](#usage)
* [Configuration](#configuration)
* [Todo](#todo)
* [License](#license)

# Features
* Lets awesomeWM to become configured using a lua agnostic configuration file like this:

```
THEME zenburn
WALLPAPER /usr/share/awesome/themes/default/background.png
TAGS WEB, IDE, TERM, FILE, 5, 6, 7, BOOK, MUSIC, WINE, GAME, 12

APPS.TERMINAL terminator
APPS.GEDITOR gvim

WIBARS.AWBAR.POSITION top
WIBARS.AWBAR.WIDGETS launcher, taglist, promptbox, carrot_battery, keyboardlayout, systray, textclock

WIBARS.TASKBAR.POSITION bottom
WIBARS.TASKBAR.WIDGETS tasklist, layoubox

AUTOSTARTS.IDE.COMMAND emacs
AUTOSTARTS.IDE.TAGS IDE

AUTOSTARTS.PASYSTRAY.COMMAND pasystray
AUTOSTARTS.BLUEMAN.COMMAND blueman-applet

AUTOSTARTS.TERM.COMMAND terminator
AUTOSTARTS.TERM.TAGS TERM, 6, 7
```

# Installation
## Prerequisites
First you need to use [awesomeWM][awesomewm] as your window manager

## AUR (Arch User Repository)
If you're using [Arch Linux][archlinux] install [awesome-carrot][aur-awesome-carrot]
package from [AUR][aur]

## luarocks
Install Carrot using lua package manager, [luarocks][luarocks]:

```shell
sudo luarocks install carrot
```

## git
Clone Carrot project into awesome configuration directory: ~/.config/awesome/

```shell
cd ~/.config/awesome
git clone https://github.com/pouyanh/carrot.git
```

# Usage
1. Start Carrot in awesomeWM config file: `~/.config/awesome/rc.lua`

```lua
local Carrot = require("carrot")

Carrot.Start()

-- Nothing more is needed for normal usage in rc.lua
```

2. Write configurations beside awesomeWM config file in: `~/.config/awesome/config`

```
THEME multicolor
```

Configuration is discussed in [Configuration](#configuration)

# Configuration

| Parameter         | Description                  | Type                 | Default                       | Example                                          |
|-------------------|------------------------------|----------------------|-------------------------------|--------------------------------------------------|
| THEME             | Theme name                   | string               | default                       | zenburn                                          |
| WALLPAPER         | Background image filepath    | string               | (empty)                       | /usr/share/awesome/themes/default/background.png |
| MOD               | Primary modifier key         | string               | Mod4                          | Mod4                                             |
| ALT               | Secondary modifier key       | string               | Mod1                          | Mod1                                             |
| TAGS              | Ordered list of tags         | []string             | 1, 2, 3, 4, 5, 6, 7, 8, 9     | WEB, IDE, TERM, FILE, BOOK, MUSIC, WINE, GAME    |
| TAGSEL            | Tag selector key group       | KeyGroup             | NUMROW                        | FUNCTION                                         |
| APPS              | Default applications         | AppList              | {                             | {                                                |
| APPS.TERMINAL     |   Default console/terminal   | string               |   "terminal": "uxvt",         |   "terminal": "terminator",                      |
| APPS.EDITOR       |   Default console editor     | string               |   "editor": $EDITOR or "vim", |   "editor": "nano",                              |
| APPS.GEDITOR      |   Default gui editor         | string               |   "geditor": "atom",          |   "geditor": "atom",                             |
| APPS.BROWSER      |   Default internet browser   | string               |   "browser": "firefox",       |   "browser": "chromium",                         |
| APPS.EXPLORER     |   Default file explorer      | string               |   "explorer": "thunar",       |   "explorer": "spacefm",                         |
| APPS.LOCKER       |   Default screen locker      | string               |   "locker": "slock",          |   "locker": "xsecurelock"                        |
| APPS.SHOTER       |   Default screen capturer    | string               |   "shoter": "scrot"           |   "shoter": "deepin-screenshot"                  |
|                   |                              |                      | }                             | }                                                |
| WIBARS            | Screens widget bars          | map[string]Wibar     | {                             |                                                  |
|                   |                              |                      |   "top": {                    |                                                  |
|                   |                              |                      |     "layout": ABC             |                                                  |
|                   |                              |                      |     "position": TOP           |                                                  |
|                   |                              |                      |     "widgets": [              |                                                  |
|                   |                              |                      |       "launcher",             |                                                  |
|                   |                              |                      |       "taglist",              |                                                  |
|                   |                              |                      |       "promptbox",            |                                                  |
|                   |                              |                      |       "carrot_battery",       |                                                  |
|                   |                              |                      |       "keyboardlayout",       |                                                  |
|                   |                              |                      |       "systray",              |                                                  |
|                   |                              |                      |       "textclock"             |                                                  |
|                   |                              |                      |     ]                         |                                                  |
|                   |                              |                      |   }                           |                                                  |
|                   |                              |                      | }                             |                                                  |
| AUTOSTARTS        | Apps would run on startup    | map[string]App       | {}                            |                                                  |

## Types

| Type      | Description                     | Definition                          | Example                                          |
|-----------|---------------------------------|-------------------------------------|--------------------------------------------------|
| KeyGroup  |                                 | NUMROW \| FUNCTION \| NUMPAD        |                                                  |
| Layout    |                                 |                                     |                                                  |
| Position  |                                 | TOP \| BOTTOM \| LEFT \| RIGHT      |                                                  |
| AppList   |                                 | {                                   |                                                  |
|           |                                 |   "terminal": string,               |                                                  |
|           |                                 |   "editor": string,                 |                                                  |
|           |                                 |   "geditor": string,                |                                                  |
|           |                                 |   "browser": string,                |                                                  |
|           |                                 |   "explorer": string,               |                                                  |
|           |                                 |   "locker": string,                 |                                                  |
|           |                                 |   "shoter": string                  |                                                  |
|           |                                 | }                                   |                                                  |
| Wibar     | A widget bar                    | {                                   |                                                  |
|           |                                 |   "layout": Layout,                 |                                                  |
|           |                                 |   "position": Position,             |                                                  |
|           |                                 |   "widgets": []string               |                                                  |
|           |                                 | }                                   |                                                  |
| App       | An application                  | {                                   |                                                  |
|           |   App run command               |   "command": string,                |                                                  |
|           |   List of bounded tags to app   |   "tags": []string                  |                                                  |
|           |                                 | }                                   |                                                  |

# Todo
1. Customize wallpaper
2. Fully customizable wibars
3. Autostart applications with default tags
4. Activate tags using one of number or function keys

# License
This software is [licensed](LICENSE) under the [GPL v3 License][gpl]. © 2018 [Janstun][janstun]

[janstun]: http://janstun.com
[awesomewm]: https://awesomewm.org/
[lua]: https://www.lua.org/
[awful]: https://awesomewm.org/doc/api/libraries/awful.layout.html
[gpl]: https://www.gnu.org/licenses/gpl-3.0.en.html
[archlinux]: https://www.archlinux.org/
[aur-awesome-carrot]: https://aur.archlinux.org/packages/awesome-carrot 
[aur]: https://wiki.archlinux.org/index.php/AUR
[luarocks]: https://luarocks.org/
