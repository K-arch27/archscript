#!/usr/bin/env bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source $SCRIPT_DIR/config.sh


mkdir /mnt &>/dev/null # Hiding error message if any
clear


echo -ne "

-------------------------------------------------------------------------
   █████╗ ██████╗  ██████╗██╗  ██╗  ██║
  ██╔══██╗██╔══██╗██╔════╝██║  ██║  ██║
  ███████║██████╔╝██║     ███████║  ██║
  ██╔══██║██╔══██╗██║     ██╔══██║  ██║ 
  ██║  ██║██║  ██║╚██████╗██║  ██║  ██║
  ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝  ╚═╝
-------------------------------------------------------------------------

"


echo -ne "
-------------------------------------------------------------------------
                    Straping Setup 
-------------------------------------------------------------------------
"


      pacstrap /mnt base base-devel linux-firmware e2fsprogs dosfstools grub grub-btrfs os-prober efibootmgr btrfs-progs ntfs-3g snapper snap-pac fish linux-zen linux-zen-headers linux-lts linux-lts-headers networkmanager sof-firmware man-db man-pages texinfo 
      
      pacstrap /mnt  xorg xorg-server xorg-xinit alacritty dolphin dolphin-plugins smplayer ark kate kcalc kolourpaint spectacle krunner partitionmanager plasma-desktop
      
      pacstrap /mnt latte-dock discord htop kruler ksysguard nano starship neofetch firefox git thefuck
      
      pacstrap /mnt noto-fonts-emoji noto-fonts-extra ttf-nerd-fonts-symbols-common zip unrar arch-install-scripts intel-ucode




clear

mkdir /mnt/MyData
mkdir /mnt/MyGames
mount /dev/sda1 /mnt/MyData
mount /dev/sdb1 /mnt/MyGames

genfstab -U /mnt >> /mnt/etc/fstab


cp -R ${SCRIPT_DIR} /mnt/root/archscript
    chmod +x /mnt/root/archscript/4chroot.sh
    chmod +x /mnt/root/archscript/5final.sh
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist


