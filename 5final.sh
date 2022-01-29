#!/usr/bin/env bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source /root/archscript/config.sh

logo
echo -ne "

-------------------------------------------------------------------------
                    Setup hostname and timezone
-------------------------------------------------------------------------
"
$NAME_OF_MACHINE > /etc/hostname
timedatectl --no-ask-password set-timezone $TIMEZONE
timedatectl --no-ask-password set-ntp 1
localectl --no-ask-password set-locale LANG="en_CA.UTF-8" LC_TIME="en_CA.UTF-8"
ln -s /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc 
# Set keymaps
localectl --no-ask-password set-keymap $KEYMAP
echo LANG=en_CA.UTF-8 > /etc/locale.conf
echo KEYMAP=$keymap > /etc/vconsole.conf
loadkeys $keymap
echo -ne "

-------------------------------------------------------------------------
        Updating full system and Setting up octopi and Aur Helper
-------------------------------------------------------------------------
"

pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
pacman-key --lsign-key FBA220DFC880C036
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
cat /root/archscript/mirror.txt >> /etc/pacman.conf
curl -O https://blackarch.org/strap.sh
chmod +x strap.sh
bash strap.sh
pacman -Syyu --noconfirm
pacman -S paru octopi snap-pac-grub stacer nerd-fonts-fantasque-sans-mono --noconfirm

