![screenshot](/src/terminal.png)

## Install scoop

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

## Install git

> scoop install git

> scoop bucket add main

> scoop bucket add extras

if need to clean cache

> scoop cache rm *

## Set up Windows Terminal

install fonts

```powershell
scoop bucket add nerd-fonts

scoop install nerd-fonts/FiraCode-NF

scoop install nerd-fonts/CascadiaCode-NF
```

add atom theme:

```powershell
notepad "$env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
```

add the code to the schemes section:

```
{
  "name": "Atom",
  "black": "#000000",
  "red": "#fd5ff1",
  "green": "#87c38a",
  "yellow": "#ffd7b1",
  "blue": "#85befd",
  "purple": "#b9b6fc",
  "cyan": "#85befd",
  "white": "#e0e0e0",
  "brightBlack": "#000000",
  "brightRed": "#fd5ff1",
  "brightGreen": "#94fa36",
  "brightYellow": "#f5ffa8",
  "brightBlue": "#96cbfe",
  "brightPurple": "#b9b6fc",
  "brightCyan": "#85befd",
  "brightWhite": "#e0e0e0",
  "background": "#161719",
  "foreground": "#c5c8c6",
  "selectionBackground": "#444444",
  "cursorColor": "#d0d0d0"
}
```

go to windows terminal settings > profiles > defaults > appearance and apply Atom theme and CaskaydiaCove Nerd Font, also set the transparency to a level you like

## Install Arch

> scoop install extras/archwsl

then run arch (from apps) and setup it

if you got any error try:

    wsl --update
    wsl --set-default-version 2
    reboot
    wsl --install -d Kali-linux    
    reboot
    scoop uninstall archwsl
    scoop install extras/archwsl

if need to use windows system proxy:

    export http_proxy="http://localhost:port"
    export https_proxy="http://localhost:port"
    source ~/.bashrc

delete proxy

    nano ~/.bashrc
    unset http_proxy
    unset https_proxy
    source ~/.bashrc

## Setting up Arch

user, replace {username}

    passwd

    echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/wheel

    nano /etc/sudoers

    uncomment: %wheel ALL=(ALL:ALL) ALL

    useradd -m -G wheel -s /bin/bash {username}

    passwd {username}

and from win:

    C:\Users\mvrshmvllxw\scoop\apps\archwsl\current\Arch.exe config --default-user {username}

keys

    gpg --refresh-keys

    sudo pacman-key --init

    sudo pacman-key --populate archlinux

    sudo pacman -Sy archlinux-keyring

    sudo pacman -Su

pacman

    sudo nano /etc/pacman.conf

pacman: check or uncomment:

    Color
    VerbosePkgLists
    ParallelDownloads = 5
    [multilib]
    Include = /etc/pacman.d/mirrorlist

pacman: add:

    ILoveCandy

mirrors

    sudo pacman -S reflector rsync

    sudo reflector --verbose --latest 15 --sort rate --save /etc/pacman.d/mirrorlist

    sudo pacman -Sy

    sudo pacman -Su

user dirs

    sudo pacman -S xdg-user-dirs

    xdg-user-dirs-update

git

    sudo pacman -S --needed base-devel git

paru (for aur packages)

    cd ~/Downloads

    git clone https://aur.archlinux.org/paru.git

    cd paru

    makepkg -si

chaotic aur

    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com

    sudo pacman-key --lsign-key 3056513887B78AEB

    sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'

    sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

    echo -e "[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf > /dev/null

    sudo pacman -Sy

fonts

    sudo pacman -S otf-font-awesome ttf-firacode-nerd ttf-cascadia-code ttf-cascadia-code-nerd ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols

fish shell

    sudo pacman -S fish

    fish

    sudo chsh -s /usr/bin/fish {username}

    echo 'set -g fish_greeting' >> ~/.config/fish/config.fish

lsd

    sudo pacman -S lsd

    echo "alias ls 'lsd'" >> ~/.config/fish/config.fish

    exec fish

starship

    sudo pacman -S starship

    curl -o ~/.config/starship.toml https://raw.githubusercontent.com/mvrshmvllxw/hyprnez/main/install_wsl/starship.toml

    or copy (cp ~/Downloads/starship.toml ~/.config/)

    echo 'starship init fish | source' >> ~/.config/fish/config.fish

## If you want your Windows to look like the screenshot

- install custom cursor (is in this repository, Neuro-sama or concept)

- place wm.exe in shell:startup, then you can manage windows by hotkeys:

```
CapsLock > change keyboard layout (shift + alt remapping)

win + r > close active windows

win + w | a | s | d > emulate win + arrow to manage windows

win + q | e > emulate hotkeys to change virtual desktop

alt + 1,2,3.. > F1, F2, F3..
```


- for transparent taskbar install TranslucentTB from 

```
https://apps.microsoft.com/detail/9pf4kz2vn4w9?hl=en-US&gl=US
```

- for transparent start menu install Windows 11 Start Menu Styler 

```
https://windhawk.net/mods/windows-11-start-menu-styler
```

- for transparent notify center install Windows 11 Notification Center Styler 

```
https://windhawk.net/mods/windows-11-notification-center-styler
```

- for clock on desktop install Monterey Rainmeter Win 

```
https://github.com/creewick/MontereyRainmeter
```

and Rainmeter clock

```
https://github.com/KazukiGames82/ttyclock-for-rainmeter
```

- for cpu and gpu temperatue in a tray install and setup HWiNFO 

```
https://www.hwinfo.com/
```