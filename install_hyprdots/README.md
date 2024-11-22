<p align="center">
  <img src="/src/hyprnez.png" alt="Logo" width="200"/>
</p>

# Screenshots

![screenshot](/src/1.png)
![screenshot](/src/2.png)
![screenshot](/src/3.png)

# Installation on a newly installed Arch with Hyprland

This script installs hyprdots on a freshly installed Arch with Hyprland. Arch installation instructions are available in the [install_arch](https://github.com/mvrshmvllxw/hyprnez/blob/main/install_arch/) folder.

### DE

- wm: hyprland
- bar: waybar
- notifies: mako
- app menu: tofi
- lockscreen: hyprlock + hypridle
- wallpapers: swww
- logout menu: wlogout
- terminal: kitty (hardcore theme,fish shell, lsd, starship with theme from Garuda Linux)
- kde and gnome theme: rose pin
- login screen: sddm (austronaut theme)
- cursor: bibata
- icons: tela-circle
- additional apps: vscode (editor, omni theme/material-icon-theme), telegram-desktop, firefox, imv (image viewer), mpv (vide viewer), wayshot (screenshots), nekoray (v2ray vpn client), obs-studio (screen recorder), dolphin (files), krabby (pokemons), fastfetch (system info), btop (catppuccin macchiato theme) and htop (processes viewers)

### Preparation (Wi-Fi)

Now let's say you just installed Arch with Hyprland and booted up. Use `Win+Q` to open Kitty (terminal), `Win+C` to close window and `Win+1`, `Win+2`... to change desktop. Press `Enter` in Kitty (several times) if a warning bothers you.

If you need Wi-Fi, connect first. Ethernet should work automatically.

```bash
> nmcli dev wifi
# replace SID_NAME and WIFI_PASSWORD
> nmcli dev wifi connect SSID_NAME password WIFI_PASSWORD
# check status
> nmcli dev status
# for disconnect
> nmcli dev disconnect wlan0
# if got any errors try
> sudo systemctl restart NetworkManager
```

### Preparation (Git)

Once you have connected to the Internet install Git:

> sudo pacman -Sy git

If you got any errors try:

```
> gpg --refresh-keys
> pacman-key --init
> pacman-key --populate archlinux
> pacman -Syu archlinux-keyring
```

### Installer 

Please note: if the top hyprland banner is constantly blinking, you first need to reboot the PC with the `reboot` command and only then run the installer (otherwise the hyprland config will not be updated due to a bug).

Now you can download repo and run installation:

```
> git clone https://github.com/mvrshmvllxw/hyprnez
> cd hyprnez/install_hyprdots
> ./install.sh
```

Do not leave your PC, the installer will ask questions and a password.

After successful installation reboot your PC:

> reboot

### Attention! If you don't need all the configs, don't run the installer, just copy the ones you need. You can find the commands for applying themes and dependencies in the 'install.sh' script, everything is commented there.

# Setup

After login press `Win+Z` to open Kitty and type:

> hyprnez

This command will show all available commands to set up these hyprdots

First of all, set wallpaper:

> hyprnez wallpaper

and type '1', then 'enter'.

# Keys

![screenshot](/src/m1.png)

# Commands

![screenshot](/src/m2.png)

# Description of the installer

The installer will perform the following steps:
1) Ask if you want to update the repository (installer).
2) Create directories for configurations.
3) Remove any auto-generated warnings, if present.
4) Enable hotkeys for copying in Kitty.
5) Copy all configuration files.
6) Ask if you want to interrupt the process here (type 'n' to continue).
7) Configure Pacman.
8) Create user directories.
9) Update mirrors.
10) Install Rust if it is not already installed.
11) Install Paru if it is not already installed.
12) Ask if you want to add Chaotic AUR.
13) Install dependencies.
14) Apply default applications.
15) Set Fish as the default shell.
16) Apply all themes.
17) Ask if you want to install Flatpak and Snapcraft.
18) Ask if you want to run the Bluetooth service.

Packages that will be installed:

```bash
# Python
paru -S --needed --noconfirm python python-pip tk tcl python-pyqt6
# Wayland and X11
paru -S --needed --noconfirm hyprland wayland-protocols xorg-xwayland wlroots
# Graphics and Video Libraries
paru -S --needed --noconfirm mesa pixman cairo pango libxcomposite libxrender qt5-wayland qt6-wayland qt5-imageformats ffmpegthumbs imagemagick
# Sound and Multimedia Libraries
paru -S --needed --noconfirm pipewire wireplumber pipewire-alsa pipewire-pulse pipewire-audio pipewire-jack gst-plugin-pipewire alsa-utils
# Development Tools
paru -S --needed --noconfirm db ninja gcc cmake meson clang parallel
# General Libraries
paru -S --needed --noconfirm libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxkbcommon xcb-util-wm fmt spdlog gtkmm3 libdbusmenu-gtk3 \
upower libmpdclient sndio gtk-layer-shell scdoc qt5ct qt6ct kconfig polkit polkit-kde-agent polkit-gnome libnotify xdg-utils shared-mime-info
# Themes and Fonts
paru -S --needed --noconfirm papirus-icon-theme tela-circle-icon-theme-all bibata-cursor-theme kvantum kvantum-qt5 otf-font-awesome ttf-firacode-nerd \
ttf-cascadia-code ttf-cascadia-code-nerd ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols ttf-cascadia-mono-nerd ttf-fira-code ttf-fira-mono ttf-fira-sans \
ttf-iosevka-nerd ttf-iosevkaterm-nerd ttf-jetbrains-mono ttf-nerd-fonts-symbols-mono noto-fonts-emoji awesome-terminal-fonts noto-fonts-cjk \
noto-fonts ttf-dejavu ttf-liberation
# Utilities and Applications
paru -S --needed --noconfirm mako network-manager-applet bluez bluez-utils blueman brightnessctl udiskie xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
nautilus dolphin gnome-text-editor waybar nwg-shell tofi wlogout wayshot archlinux-xdg-menu fish kitty lsd starship krabby less hypridle hyprlock jq \
xdg-desktop-portal-kde nwg-displays fastfetch htop btop
# Viewer and Editor Applications
paru -S --needed --noconfirm code code-features code-marketplace firefox telegram-desktop imv mpv
# System Utilities
paru -S --needed --noconfirm kde-cli-tools kservice5 pacman-contrib python-pyamdgpuinfo xorg-xinput seatd
# Nvidia
paru -S --needed --noconfirm nvidia
# VPN
paru -S --needed --noconfirm nekoray
# Fixes for Steam
sudo pacman -S --needed --noconfirm lib32-libx11 lib32-libxcomposite lib32-libxrandr lib32-libxinerama lib32-libxcursor lib32-mesa lib32-vulkan-icd-loader \
lib32-pipewire lib32-glibc lib32-gtk2 lib32-gtk3 lib32-gnutls lib32-libpulse lib32-openal
```

# Additional

### Telegram theme

```
https://t.me/addtheme/BChppF8BUJCY9EW9
```

### Firefox theme

```
https://addons.mozilla.org/en-US/firefox/addon/nezuko/
```

### Firefox delete window close button

Type `about:config` in URL bar.

Set `toolkit.legacyUserProfileCustomizations.stylesheets` to true.

Type `about:support`. Copy address from Open profile direcory button.

(for example /home/mvrshmvllxw/.mozilla/firefox/gckgzl7s.default-release)

Create file directory 'chrome':

mkdir -p /home/mvrshmvllxw/.mozilla/firefox/`gckgzl7s.default-release`/chrome`

And file:

sudo nano  /home/mvrshmvllxw/.mozilla/firefox/`gckgzl7s.default-release`/chrome/userChrome.css

Add to file:

`.titlebar-buttonbox-container{display:none} `

# NVidia drivers

If you are installing Hyprland not on a clean Arch with pre-installed Hyprland and video drivers, then you should read https://wiki.hyprland.org/Nvidia/



