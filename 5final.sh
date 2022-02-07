#!/usr/bin/env bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source /root/archscript/config.sh

logo
echo -ne "

-------------------------------------------------------------------------
                    Setup hostname and timezone
-------------------------------------------------------------------------
"
echo "$NAME_OF_MACHINE" > /etc/hostname
timedatectl --no-ask-password set-timezone $TIMEZONE
timedatectl --no-ask-password set-ntp 1
localectl --no-ask-password set-locale LANG="$LANGLOCAL" LC_TIME="$LANGLOCAL"
ln -s /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc 
# Set keymaps
echo KEYMAP=$KEYMAP > /etc/vconsole.conf
loadkeys $KEYMAP
localectl --no-ask-password set-keymap $KEYMAP
localectl set-x11-keymap --no-convert "$KEYMAP"
echo "LANG=${LANGLOCAL}" > /etc/locale.conf

echo -ne "

-------------------------------------------------------------------------
        Updating full system and Setting up octopi and Aur Helper
-------------------------------------------------------------------------
"
#adding chaotic-Aur and Black Arch Repo
pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
pacman-key --lsign-key FBA220DFC880C036
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm
cat /root/archscript/mirror.txt >> /etc/pacman.conf
curl -O https://blackarch.org/strap.sh
chmod +x strap.sh
bash strap.sh
rm /strap.sh
pacman -Syyu --noconfirm
pacman -S paru octopi snap-pac-grub stacer nerd-fonts-fantasque-sans-mono --noconfirm

#Changing The timeline auto-snap
sed -i 's|QGROUP=""|QGROUP="1/0"|' /etc/snapper/configs/root
sed -i 's|NUMBER_LIMIT="50"|NUMBER_LIMIT="10-35"|' /etc/snapper/configs/root
sed -i 's|NUMBER_LIMIT_IMPORTANT="50"|NUMBER_LIMIT_IMPORTANT="10-25"|' /etc/snapper/configs/root
sed -i 's|TIMELINE_LIMIT_HOURLY="10"|TIMELINE_LIMIT_HOURLY="3"|' /etc/snapper/configs/root
sed -i 's|TIMELINE_LIMIT_DAILY="10"|TIMELINE_LIMIT_DAILY="3"|' /etc/snapper/configs/root
sed -i 's|TIMELINE_LIMIT_WEEKLY="0"|TIMELINE_LIMIT_WEEKLY="2"|' /etc/snapper/configs/root
sed -i 's|TIMELINE_LIMIT_MONTHLY="10"|TIMELINE_LIMIT_MONTHLY="2"|' /etc/snapper/configs/root
sed -i 's|TIMELINE_LIMIT_YEARLY="10"|TIMELINE_LIMIT_YEARLY="0"|' /etc/snapper/configs/root

#activating the auto-cleanup
SCRUB=$(systemd-escape --template btrfs-scrub@.timer --path /dev/disk/by-uuid/${ROOTUUID})
systemctl enable ${SCRUB}
systemctl enable snapper-timeline.timer
systemctl enable snapper-cleanup.timer

