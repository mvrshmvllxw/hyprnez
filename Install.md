# Download ISO

Download distro and boot from usb https://archlinux.org/download/

From Windows use Rufus or Balenaetcher to make bootable usb.

# Connect to Wi-Fi

Internet required for installation, set up Wi-Fi or skip this step if you use Ethernet.

```bash
iwctl
device list
# If Wi-Fi powered off, replace NAME and ADAPTER
device NAME set-property Powered on
adapter ADAPTER set-property Powered on
# Scan and connect, replace NAME and SSID
station NAME scan
station NAME get-networks
station NAME connect SSID
exit
```

# Run automatic installer

The minimal command:

> archinstall

But to prevent possible errors I recommend doing it this way:

```
> gpg --refresh-keys
> pacman-key --init
> pacman-key --populate archlinux
> pacman -Sy archlinux-keyring
> pacman -S reflector rsync python
> reflector --verbose --latest 15 --sort rate --save /etc/pacman.d/mirrorlist
> archinstall
```

# Configure Installer

Set the settings:

	profile > type > desktop > Hyprland (polkit)

The rest is as you like, but I recommend:

	bootloader: systemd-boot
	audio driver: pipeware
	network: networkmanager
	repositories: multilib

Install and

> reboot

or 

> exit

> reboot