# :carrot: Carrot awesomeWM personalization application
* Do you want to have a __light__ and __geeky__ desktop environment, full of tiny widgets, on your linux?
* Have you ever wondered if you could configure [awesomeWM](https://awesomewm.org)
without learning [lua](https://www.lua.org/)
and reading [awful](https://awesomewm.org/doc/api/libraries/awful.layout.html) documents?

__Thanks God__, for creating :carrot:

## Contents
* [Features](#installation)
* [Installation](#installation)
    * [Prerequisites](#prerequisites)
    * [AUR (Arch User Repository)](#aur-(arch-user-repository))
    * [luarocks](#luarocks)
    * [git](#git)
* [Usage](#usage)
* [Todo](#todo)

## Features
* Lets awesomeWM to become configured using a lua agnostic configuration file like this:

```
THEME zenburn
WALLPAPER /usr/share/awesome/themes/default/background.png
TAGS WEB, IDE, TERM, FILE, 5, 6, 7, BOOK, MUSIC, WINE, GAME

APPS.TERMINAL terminator
APPS.GEDITOR gvim

WIBARS.TOP.POSITION top
WIBARS.TOP.WIDGETS launcher, taglist, promptbox, carrot_battery, keyboardlayout, systray, textclock
```

## Installation
### Prerequisites
First you need to use [awesomeWM](https://awesomewm.org/) as your window manager

### AUR (Arch User Repository)
If you're using [Arch Linux](https://www.archlinux.org/) install [awesome-carrot](#https://aur.archlinux.org/packages/awesome-carrot)

### luarocks
Install Carrot using lua package manager, [luarocks](https://luarocks.org/):

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
1. Start Carrot in awesomeWM config
Use 

2. Configure it

## Todo
1. Fully customizable wibars

## License
This software is licensed under the [GPL v3 licence][gpl].
© 2018 Janstun
