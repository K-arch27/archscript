#!/usr/bin/env bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source /archscript/config.sh

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




#required Package
pacstrap /mnt base base-devel linux-zen linux-zen-headers fish linux-firmware e2fsprogs dosfstools grub grub-btrfs os-prober efibootmgr btrfs-progs
pacstrap /mnt networkmanager sof-firmware ntfs-3g man-db man-pages texinfo xorg xorg-server snapper snap-pac

#My choice of firmware and shell can be changed for yours but don't forget of also modifiying the shell in the useradd command


#those line bellow can be changed for another DE/Apps set
pacstrap /mnt  plasma konsole dolphin dolphin-plugins ark kate kcalc kolourpaint spectacle krunner partitionmanager packagekit-qt5 sddm 
pacstrap /mnt latte-dock discord filelight htop kruler ksysguard yakuake nano starship neofetch firefox git
pacstrap /mnt noto-fonts-emoji noto-fonts-extra ttf-nerd-fonts-symbols 
echo -ne "

-------------------------------------------------------------------------
                    Installing Microcode
-------------------------------------------------------------------------
"
# determine processor type and install microcode
proc_type=$(lscpu)
if grep -E "GenuineIntel" <<< ${proc_type}; then
    echo "Installing Intel microcode"
    pacman -S --noconfirm intel-ucode
    proc_ucode=intel-ucode.img
elif grep -E "AuthenticAMD" <<< ${proc_type}; then
    echo "Installing AMD microcode"
    pacman -S --noconfirm amd-ucode
    proc_ucode=amd-ucode.img
fi

clear

genfstab -U /mnt >> /mnt/etc/fstab


cp -R ${SCRIPT_DIR} /mnt/root/archscript
    chmod +x /mnt/root/archscript/4chroot.sh
    chmod +x /mnt/root/archscript/5final.sh
    chmod +x /mnt/root/archscript/6log.sh
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist


