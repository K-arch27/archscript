#!/usr/bin/env bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source /root/archscript/setup.conf
echo -ne "
-------------------------------------------------------------------------
   █████╗ ██████╗  ██████╗██╗  ██╗ ███████
  ██╔══██╗██╔══██╗██╔════╝██║  ██║ ╚═══╝██
  ███████║██████╔╝██║     ███████║ ███████
  ██╔══██║██╔══██╗██║     ██╔══██║ ██╚═══╝ 
  ██║  ██║██║  ██║╚██████╗██║  ██║ ███████
  ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝
-------------------------------------------------------------------------

"

echo -ne "
-------------------------------------------------------------------------
                    Network Setup 
-------------------------------------------------------------------------
"

systemctl enable --now NetworkManager


echo -ne "

-------------------------------------------------------------------------
                    Setup Language to EN and set Admin rights
-------------------------------------------------------------------------
"
sed -i 's/^#en_CA.UTF-8 UTF-8/en_CA.UTF-8 UTF-8/' /etc/locale.gen
locale-gen


# Add sudo no password rights
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

#Add parallel downloading
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf

#Enable multilib
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
pacman -Sy --noconfirm
clear

echo -ne "
-------------------------------------------------------------------------
                    Adding User
-------------------------------------------------------------------------
"

groupadd libvirt
useradd -m -G wheel,libvirt -s /bin/fish $USERNAME

# use chpasswd to enter $USERNAME:$password
echo "$USERNAME:$PASSWORD" | chpasswd
echo "root:$ROOTPASSWORD" | chpasswd

systemctl enable sddm
mkinitcpio -p linux

umount /.snapshots
rm -r /.snapshots
snapper --no-dbus -c root create-config /
btrfs subvolume delete /.snapshots
mkdir /.snapshots
mount -a
chmod 750 /.snapshots
clear
echo -ne "
-------------------------------------------------------------------------
                  Grub Install
-------------------------------------------------------------------------
"

grub-install --target=x86_64-efi --efi-directory=/boot/ESP --bootloader-id=GRUB --modules="normal test efi_gop efi_uga search echo linux all_video gfxmenu gfxterm_background gfxterm_menu gfxterm loadenv configfile gzio part_gpt btrfs"

grub-mkconfig -o /boot/grub/grub.cfg

sed -i 's/rootflags=subvol=${rootsubvol}//' /etc/grub.d/10_linux
sed -i 's/rootflags=subvol=${rootsubvol}//' /etc/grub.d/20_linux_xen
sed -i 's/,subvolid=258,subvol=/@/.snapshots/1/snapshot//' /etc/fstab
