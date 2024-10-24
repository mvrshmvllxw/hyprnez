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
    if grep -q 'autogenerated=1' ~/.config/hypr/hyprland.conf; then
        echo "::: Removing the autogenerated warning in Hyprland config..."
        sed -i 's/autogenerated=1/autogenerated=0/' ~/.config/hypr/hyprland.conf
    fi
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
sudo cp -rf usr/* /usr/
cp -rf wallpapers/* ~/Pictures/Wallpapers/
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
    rm -rf ~/Downloads/paru
fi

###################

echo -e "\e[35m::: Do you want to add Chaotic Aur? Skip this step if you get an error with Chaotic Aur.\e[0m (y/n): \c"
read user_input
if [ "$user_input" = "y" ] || [ "$user_input" = "Y" ]; then
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
    if [ $chaotic_error -ne 1 ]; then
        if ! grep -q "^$$chaotic-aur$$" /etc/pacman.conf; then
            echo "\n\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf > /dev/null
            echo "::: The section [chaotic-aur] added in /etc/pacman.conf"
        else
            echo "::: The section [chaotic-aur] already exists in /etc/pacman.conf"
        fi
        echo "::: Chaotic AUR has been configured successfully."
    else
        echo "::: There was an error earlier, so the configuration was not modified."
        echo "::: Chaotic AUR has not been configured. See errors above."
    fi
else
    echo "::: Installation Chaotic Aur has been canceled."
fi



###################

echo "::: Installing dependencies.with paru..."
if ! command -v paru &> /dev/null; then
    echo -e "\e[35m(!) Paru is not installed. Please install paru first.\e[0m"
    exit 1
fi
# Main components
paru -S --needed --noconfirm hyprland wayland-protocols xorg-xwayland wlroots mesa
# Sound and multimedia
paru -S --needed --noconfirm pipewire wireplumber pipewire-alsa pipewire-pulse pipewire-audio \
pipewire-jack gst-plugin-pipewire pavucontrol pamixer
# Dev
paru -S --needed --noconfirm db ninja gcc cmake meson clang parallel
# Libraries
paru -S --needed --noconfirm libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite \
libxrender pixman cairo pango libxkbcommon xcb-util-wm fmt spdlog gtkmm3 libdbusmenu-gtk3 upower libmpdclient \
sndio gtk-layer-shell scdoc qt5-wayland qt6-wayland qt5ct qt6ct kconfig kconfig polkit polkit-kde-agent polkit-gnome \
libnotify xdg-utils
# Theming
paru -S --needed --noconfirm papirus-icon-theme tela-circle-icon-theme-all bibata-cursor-theme kvantum kvantum-qt5
# Apps and utils
paru -S --needed --noconfirm mako network-manager-applet bluez bluez-utils blueman brightnessctl udiskie xdg-desktop-portal-hyprland \
xdg-desktop-portal-gtk nautilus dolphin gnome-text-editor waybar swww nwg-shell tofi wlogout wayshot archlinux-xdg-menu \
mpvpaper fish kitty lsd starship krabby less hypridle hyprlock jq 
# View apps
paru -S --needed --noconfirm mpv imv code code-features code-marketplace firefox telegram-desktop
# System utils
paru -S --needed --noconfirm kde-cli-tools kservice5 pacman-contrib python-pyamdgpuinfo xorg-xinput seatd 
# Images
paru -S --needed --noconfirm drawing imagemagick qt5-imageformats ffmpegthumbs
echo "::: Packages installation complete."

###################

echo "::: Installing fonts..."
sudo pacman -S --noconfirm --needed otf-font-awesome ttf-firacode-nerd ttf-cascadia-code ttf-cascadia-code-nerd \
ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols ttf-cascadia-mono-nerd ttf-fira-code ttf-fira-mono ttf-fira-sans ttf-iosevka-nerd \
ttf-iosevkaterm-nerd ttf-jetbrains-mono ttf-nerd-fonts-symbols-mono noto-fonts-emoji awesome-terminal-fonts noto-fonts-cjk noto-fonts
echo "::: Installation completed."

###################

echo "::: Applying default apps..."
# Video
xdg-mime default mpv.desktop video/mp4
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
echo "::: Applying SDDM theme..."
sudo sed -i '/$$Theme$$/a Current=sddm-astronaut-theme' /etc/sddm.conf
echo "::: Applying wallpapers slideshow service"
systemctl --user daemon-reload

###################

echo -e "\e[35m::: Do you want to install Flatpak and Snapcraft?\e[0m (y/n): \c"
read user_input_store
if [[ "$user_input_store" == "y" || "$user_input_store" == "Y" ]]; then
    echo "::: Installing Flatpak..."
    sudo pacman -S --needed --noconfirm flatpak
    if ! command -v snap &> /dev/null; then
        echo "::: Installing Snapcraft..."
        cd ~/Downloads
        git clone https://aur.archlinux.org/snapd.git
        cd snapd
        makepkg -si
        sudo systemctl enable --now snapd.socket
        sudo pacman -S --needed --noconfirm apparmor
        sudo systemctl start apparmor.service
        sudo systemctl enable --now snapd.apparmor.service
    else
        echo "::: Snapcraft already installed."
    fi
    # Return to the original directory
    cd "$original_dir"
    rm -rf ~/Downloads/snapd
else
    echo "::: Installation of Flatpak and Snapcraft has been canceled."
fi

###################

echo -e "\e[35m::: Do you want to enable Bluetooth service?\e[0m (y/n): \c"
read bluetooth
if [[ "$bluetooth" == "y" || "$bluetooth" == "Y" ]]; then
    echo "::: Enabling Bluetooth service..."
    sudo systemctl enable bluetooth.service
    sudo systemctl restart bluetooth.service
else
    echo "::: Cancelled by user."
fi


###################

echo -e "\e[35m::: Well done.\e[0m"
echo -e "\e[35m::: Now please type 'reboot'.\e[0m"
echo -e "\e[35m::: After login use 'win+z' top open Terminal.\e[0m"
echo -e "\e[35m::: Type 'hyprnez keys' to see default keybinds.\e[0m"
echo -e "\e[35m::: Type 'hyprnez' to see all commands.\e[0m"
echo -e "\e[35m::: Type 'hyprnez config monitor' to edit monitor config.\e[0m"
echo -e "\e[35m::: Type 'hyprnez nezuko' to set default wallpaper (only after reboot)\e[0m"