# :carrot: Carrot awesomeWM personalization application
* Do you want to have a __light__ and __geeky__ desktop environment, full of tiny widgets, on your linux?
* Have you ever wondered if you could configure [awesomeWM][awesomewm]
without learning [lua][lua]
and reading [awful][awful] documents?

__Thanks God__, for creating :carrot:

## Contents
* [Features](#installation)
* [Installation](#installation)
    * [Prerequisites](#prerequisites)
    * [AUR (Arch User Repository)](#aur-arch-user-repository)
    * [luarocks](#luarocks)
    * [git](#git)
* [Usage](#usage)
* [Configuration](#configuration)
* [Todo](#todo)
* [License](#license)

## Features
* Lets awesomeWM to become configured using a lua agnostic configuration file like this:

```
THEME zenburn
WALLPAPER /usr/share/awesome/themes/default/background.png
TAGS WEB, IDE, TERM, FILE, 5, 6, 7, BOOK, MUSIC, WINE, GAME, 12

APPS.TERMINAL terminator
APPS.GEDITOR gvim

WIBARS.TOP.POSITION top
WIBARS.TOP.WIDGETS launcher, taglist, promptbox, carrot_battery, keyboardlayout, systray, textclock
```

## Installation
### Prerequisites
First you need to use [awesomeWM][awesomewm] as your window manager

### AUR (Arch User Repository)
If you're using [Arch Linux][archlinux] install [awesome-carrot][aur-awesome-carrot]
package from [AUR][aur]

### luarocks
Install Carrot using lua package manager, [luarocks][luarocks]:

```shell
sudo luarocks install carrot
```

### git
Clone Carrot project into awesome configuration directory: ~/.config/awesome/

```shell
cd ~/.config/awesome
git clonet https://github.com/pouyanh/carrot.git
```

## Usage
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

## Configuration

|   Parameter   |         Description          |      Type     |          Default          |                     Example                      |
|---------------|------------------------------|---------------|---------------------------|--------------------------------------------------|
| THEME         | Theme name                   | string        | default                   | zenburn                                          |
| WALLPAPER     | Background image filepath    | string        | (empty)                   | /usr/share/awesome/themes/default/background.png |
| MOD           | Primary modifier key         | string        | Mod4                      | Mod4                                             |
| ALT           | Secondary modifier key       | string        | Mod1                      | Mod1                                             |
| TAGS          | Ordered list of tags         | array(string) | 1, 2, 3, 4, 5, 6, 7, 8, 9 | WEB, IDE, TERM, FILE, BOOK, MUSIC, WINE, GAME    |
| APPS.TERMINAL | Default console/terminal     | string        | uxvt                      | terminator                                       |
| APPS.EDITOR   | Default console editor       | string        | $EDITOR or vim            | nano                                             |
| APPS.GEDITOR  | Default gui editor           | string        | atom                      | gvim                                             |
| APPS.BROWSER  | Default internet browser     | string        | firefox                   | chromium                                         |
| APPS.EXPLORER | Default file explorer        | string        | thunar                    | spacefm                                          |
| APPS.LOCKER   | Default screen locker        | string        | slock                     | xsecurelock                                      |
| APPS.SHOTER   | Defaylt screen capturer      | string        | scrot                     | deepin-screenshot                                |

## Todo
1. Fully customizable wibars

## License
This software is licensed under the [GPL v3 license][gpl]. © 2018 Janstun

[awesomewm]: https://awesomewm.org/
[lua]: https://www.lua.org/
[awful]: https://awesomewm.org/doc/api/libraries/awful.layout.html
[gpl]: http://www.gnu.org/copyleft/gpl.html
[archlinux]: https://www.archlinux.org/
[aur-awesome-carrot]: https://aur.archlinux.org/packages/awesome-carrot 
[aur]: https://wiki.archlinux.org/index.php/AUR
[luarocks]: https://luarocks.org/
