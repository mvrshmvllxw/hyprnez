<p align="center">
  <img src="/src/hyprnez.png" alt="Logo" width="200"/>
</p>

# Screenshots

![screenshot](/src/1.png)
![screenshot](/src/2.png)
![screenshot](/src/3.png)

# Installation on a newly installed Arch with Hyprland

This script installs hyprdots on a freshly installed Arch with Hyprland. Arch installation instructions are available in the [install_arch](https://github.com/mvrshmvllxw/hyprnez/blob/main/install_arch/) folder.


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

Please note: If the top hyprland banner is constantly blinking, you first need to reboot the PC with the `reboot` command and only then run the installer (otherwise the hyprland config will not be updated due to a bug).

Now you can download repo and run installation:

```
> git clone https://github.com/mvrshmvllxw/hyprnez
> cd hyprnez/install_hyprdots
> ./install.sh
```

Do not leave your PC, the installer will ask questions and a password.

After successful installation reboot your PC:

> reboot

# Setup

After login press `Win+Z` to open Kitty and type:

> hyprnez keys

This command will show all available commands to set up these hyprdots

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



