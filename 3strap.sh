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


#always
      pacstrap /mnt base base-devel linux-firmware e2fsprogs dosfstools grub grub-btrfs os-prober efibootmgr btrfs-progs ntfs-3g snapper snap-pac fish linux-lts linux-lts-headers networkmanager sof-firmware man-db man-pages texinfo 
      
      pacstrap /mnt noto-fonts-emoji noto-fonts-extra ttf-nerd-fonts-symbols-common zip unrar arch-install-scripts yay
      
#desktop


      pacstrap /mnt  xorg xorg-server xorg-xinit alacritty dolphin dolphin-plugins smplayer ark kate kcalc kolourpaint spectacle krunner partitionmanager plasma-desktop linux-zen linux-zen-headers 
      
      pacstrap /mnt latte-dock discord htop kruler ksysguard nano starship neofetch firefox git thefuck octopi btrfs-assistant



clear


genfstab -U /mnt >> /mnt/etc/fstab


cp -R ${SCRIPT_DIR} /mnt/root/archscript
    chmod +x /mnt/root/archscript/4chroot.sh
    chmod +x /mnt/root/archscript/5final.sh
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist


