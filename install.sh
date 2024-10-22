#!/bin/bash
# Enable error handling
set -e
# Function to handle errors
error_handler() {
    echo "::: Error occurred in script at line: $1"
    exit 1
}
# Trap errors and call the error handler
trap 'error_handler $LINENO' ERR

###################

echo -e "\e[35m::: Do you want to update this repo before installing?\e[0m (y/n): \c"
read update
if [[ "$update" == "y" || "$update" == "Y" ]]; then
    echo "::: Updating..."
    git pull
    echo "::: Restarting script..."
    exec "$0"
else
    echo "::: Continue without updating."
fi

###################

echo "::: Saving currently directory..."
original_dir=$(pwd)

###################

BIN_DIR="$HOME/.local/share/bin"
DIRSCR="$HOME/Pictures/Screenshots"
WALLPAPERS="$HOME/Pictures/Wallpapers"
LIVE="$HOME/Pictures/Live"
DOWNLOADS="$HOME/Downloads"
THEMES="$HOME/.themes"
for DIR in "$BIN_DIR" "$DIRSCR" "$DOWNLOADS" "$WALLPAPERS" "$LIVE" "$THEMES"; do
    if [ ! -d "$DIR" ]; then
        echo "::: Creating directory: $DIR"
        mkdir -p "$DIR"
    fi
done

###################

if [ -f ~/.config/hypr/hyprland.conf ]; then
    echo "::: Removing the autogenerated warning in Hyprland config..."
    sed -i 's/autogenerated=1/autogenerated=0/' ~/.config/hypr/hyprland.conf
fi

###################

if [ ! -f ~/.config/kitty/kitty.conf ]; then
    echo "::: Enabling copy/paste shortcuts in Kitty..."
    echo -e "\nmap ctrl+c copy_and_clear_or_interrupt\nmap ctrl+v paste_from_clipboard" >> ~/.config/kitty/kitty.conf
fi

###################

echo "::: Copying configuration files..."
cp -rf .config/* ~/.config/
cp -rf .themes/* ~/.themes/
echo "::: Need password to copy scripts:"
sudo cp -rf usr/* /usr/
echo "::: Done."

###################

echo -e "\e[35m::: Configs copied. Do you want to abort the installation?\e[0m (y/n): \c"
read abort
if [[ "$abort" == "y" || "$abort" == "Y" ]]; then
    echo "::: Installation aborted by user."
    exit 0
fi

###################

echo "::: Pacman configuring..."
gpg --refresh-keys
sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman -Sy --noconfirm archlinux-keyring
sudo sed -i 's/#Color/Color/' /etc/pacman.conf
sudo sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/' /etc/pacman.conf
sudo sed -i 's/#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf
if ! grep -q '^ILoveCandy' /etc/pacman.conf; then
    sudo sed -i '/^#DisableSandbox/a ILoveCandy' /etc/pacman.conf || sudo sed -i '/^Color/a ILoveCandy' /etc/pacman.conf
fi
echo "::: Updating system..."
sudo pacman -Su --noconfirm 
echo "::: Pacman configured."

###################

echo "::: Configuring user dirs..."
sudo pacman -S --needed --noconfirm xdg-user-dirs
xdg-user-dirs-update

###################

echo "::: Installing base-devel..."
sudo pacman -S --needed --noconfirm base-devel

###################

echo "::: Updating mirrors with Reflector..."
sudo pacman -S --needed --noconfirm reflector rsync
sudo reflector --verbose --latest 15 --sort rate --save /etc/pacman.d/mirrorlist
echo "::: Updating system..."
sudo pacman -Syu

###################

echo "::: Checking if Rust installed..."
if command -v rustc >/dev/null 2>&1; then
    echo "::: Rust is already installed."
else
    echo "::: Installing Rust..."
    sudo pacman -S --noconfirm --needed rustup && rustup install stable
    echo "::: Rust installed."
fi

###################

echo "::: Checking if Paru installed..."
if command -v paru >/dev/null 2>&1; then
    echo "::: Paru is already installed."
else
    echo "::: Installing Paru..."
    cd ~/Downloads
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si
    cd "$original_dir"
fi

###################

echo "::: Installing dependencies.with paru..."
if ! command -v paru &> /dev/null; then
    echo -e "\e[35m(!) Paru is not installed. Please install paru first.\e[0m"
    exit 1
fi
paru -S --needed --noconfirm hyprland pipewire wireplumber gdb ninja gcc cmake \
libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite \
xorg-xinput libxrender pixman wayland-protocols cairo pango seatd libxkbcommon \
xcb-util-wm xorg-xwayland wlroots mesa meson polkit fmt spdlog gtkmm3 \
libdbusmenu-gtk3 upower libmpdclient sndio gtk-layer-shell scdoc clang \
jq xdg-desktop-portal-hyprland polkit-kde-agent papirus-icon-theme \
qt5-wayland qt6-wayland qt5ct qt6ct kvantum kvantum-qt5 kconfig kde-cli-tools \
qt5-tools hypridle hyprlock mako network-manager-applet pipewire-alsa pipewire-pulse \
gst-plugin-pipewire pavucontrol pamixer bluez bluez-utils blueman brightnessctl \
udiskie xdg-desktop-portal-gtk nautilus dolphin gnome-text-editor waybar swww \
nwg-shell tela-circle-icon-theme-all bibata-cursor-theme tofi wlogout \
pipewire-audio pipewire-jack gst-plugin-pipewire polkit-gnome \
xdg-desktop-portal-hyprland pacman-contrib python-pyamdgpuinfo parallel jq \
imagemagick qt5-imageformats ffmpegthumbs kde-cli-tools kservice5 libnotify \
xdg-utils wayshot archlinux-xdg-menu mpvpaper gimp drawing fish kitty lsd starship
paru -S --needed --noconfirm mpv imv code code-features code-marketplace firefox telegram-desktop
echo "::: Packages installation complete."

###################

echo "::: Installing fonts..."
sudo pacman -S --noconfirm --needed otf-font-awesome ttf-firacode-nerd ttf-cascadia-code ttf-cascadia-code-nerd \
ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols ttf-cascadia-mono-nerd ttf-fira-code ttf-fira-mono ttf-fira-sans ttf-iosevka-nerd \
ttf-iosevkaterm-nerd ttf-jetbrains-mono ttf-nerd-fonts-symbols-mono noto-fonts-emoji awesome-terminal-fonts
echo "::: Installation completed."

###################

echo "::: Applying default apps..."
# Fix mime bugs
XDG_MENU_PREFIX=arch- kbuildsycoca6
# Video
wayshoxdg-mime default mpv.desktop video/mp4
xdg-mime default mpv.desktop video/x-matroska
xdg-mime default mpv.desktop video/webm
# Pics
xdg-mime default imv.desktop image/jpeg
xdg-mime default imv.desktop image/png
xdg-mime default imv.desktop image/gif
echo "::: Done."

###################

echo "::: Setting fish as the default shell..."
chsh -s $(which fish)

#script to set theme from github
# THEMENAME="Hardcore"
# THEME_URL="https://raw.githubusercontent.com/dexpota/kitty-themes/master/themes/$THEMENAME.conf"
# wget "$THEME_URL" -P ~/.config/kitty/kitty-themes/
# ln -sf ~/.config/kitty/kitty-themes/$THEMENAME.conf ~/.config/kitty/theme.conf

###################

echo "::: Applying appearance..." 
echo "::: Applying icons for KDE apps..."
kwriteconfig6 --file ~/.config/kdeglobals --group Icons --key Theme 'Tela-circle-blue'
echo "::: Applying icons for GNOME apps..."
gsettings set org.gnome.desktop.interface icon-theme 'Tela-circle-blue'
echo "::: Applying GNOME theme..."
gsettings set org.gnome.desktop.interface gtk-theme 'Rose-Pine'
echo "::: Turning on GNOME dark scheme..."
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
echo "::: Setting KDE theme to Kvantum..."
kwriteconfig6 --file kdeglobals --group KDE --key widgetStyle kvantum-dark
kwriteconfig6 --file kdeglobals --group General --key ColorScheme Kvantum
echo "::: Applying cursor theme for KDE..."
kwriteconfig6 --file ~/.config/kcminputrc --group Mouse --key cursorTheme Bibata-Original-Ice
echo "::: Applying cursor theme for GNOME..."
gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Original-Ice'
echo "::: Applying cursor theme for Hyprland..."
hyprctl setcursor Bibata-Original-Ice 24
echo "::: Applying cursor theme for SDDM..."
sudo sed -i '/$$Theme$$/a CursorSize=24\nCursorTheme=Bibata-Original-Ice' /etc/sddm.conf
echo "::: Copying wallpapers..."
cp wallpapers/nezuko.jpg ~/Pictures/Wallpapers/
echo "::: Applying SDDM theme..."
sudo sed -i '/$$Theme$$/a Current=sddm-astronaut-theme' /etc/sddm.conf
echo "::: Applying wallpapers slideshow service"
systemctl --user daemon-reload

###################

echo -e "\e[35m::: Do you want to install Flatpak, Snapcraft and Chaotic Aur? Skip this step if you get an error with Chaotic Aur.\e[0m (y/n): \c"
read user_input
if [[ "$user_input" == "y" || "$user_input" == "Y" ]]; then
    echo "::: Installing Flatpak..."
    sudo pacman -S --needed --noconfirm flatpak
    echo "::: Installing Snapcraft..."
    cd ~/Downloads
    git clone https://aur.archlinux.org/snapd.git
    cd snapd
    makepkg -si
    sudo systemctl enable --now snapd.socket
    sudo pacman -S --needed --noconfirm apparmor
    sudo systemctl start apparmor.service
    sudo systemctl enable --now snapd.apparmor.service
    # Return to the original directory
    cd "$original_dir"
    # Chaotic Aur
    chaotic_error=0
    echo "Configuring Chaotic AUR..."
    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
    sudo pacman-key --lsign-key 3056513887B78AEB
    if ! sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'; then
        echo "(!) Error: Failed to download or install chaotic-keyring.pkg.tar.zst."
        echo "(!) Please check your internet connection or try again later."
        echo "(!) URL: https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst"
        chaotic_error=1
    fi
    if ! sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'; then
        echo "(!) Error: Failed to download or install chaotic-mirrorlist.pkg.tar.zst."
        echo "(!) Please check your internet connection or try again later."
        echo "(!) URL: https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst"
        chaotic_error=1
    fi
    if [[ $chaotic_error -ne 1 && ! $(grep -q "^$$chaotic-aur$$$" /etc/pacman.conf) ]]; then
        echo -e "\n\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf > /dev/null
        echo "::: The section [chaotic-aur] added in /etc/pacman.conf"
    else
        if [[ $chaotic_error -eq 1 ]]; then
            echo "::: There was an error earlier, so the configuration was not modified."
        else
            echo "::: The section [chaotic-aur] already exists in /etc/pacman.conf"
        fi
    fi
    if [[ $chaotic_error -ne 1 ]]; then
        echo "::: Chaotic AUR has been configured successfully."
    else
        echo "::: Chaotic AUR has not been configured. See errors above."
    fi
else
    echo "::: Installation of Flatpak, Snapcraft and Chaotic Aur has been canceled."
fi

echo -e "\e[35m::: Do you want to enable Bluetooth service?\e[0m (y/n): \c"
read bluetooth
if [[ "$bluetooth" == "y" || "$bluetooth" == "Y" ]]; then
    echo "::: Enabling Bluetooth service..."
    sudo systemctl enable bluetooth.service
    sudo systemctl restart bluetooth.service
else
    echo "::: Cancelled by user."
fi



echo -e "\e[35m::: Well done.\e[0m"
echo -e "\e[35m::: Now please type 'reboot'.\e[0m"
echo -e "\e[35m::: After login use 'win+z' top open Terminal.\e[0m"
echo -e "\e[35m::: Type 'hyprnez keys' to see default keybinds.\e[0m"
echo -e "\e[35m::: Type 'hyprnez' to see all commands.\e[0m"
echo -e "\e[35m::: Type 'hyprnez config monitor' to edit monitor config.\e[0m"
echo -e "\e[35m::: Type 'hyprnez nezuko' to set default wallpaper (only after reboot)\e[0m"