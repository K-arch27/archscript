#!/usr/bin/env bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source /root/archscript/config.sh
clear
logo
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
sed -i "s/^#${LANGLOCAL}/${LANGLOCAL}/" /etc/locale.gen
locale-gen


# Add sudo rights
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers


#Add parallel downloading
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf

#Enable multilib
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
pacman -Sy --noconfirm
clear
logo
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
logo
echo -ne "
-------------------------------------------------------------------------
                  Grub Install
-------------------------------------------------------------------------
"

grub-install --target=x86_64-efi --efi-directory=/boot/ESP --bootloader-id=GRUB --modules="normal test efi_gop efi_uga search echo linux all_video gfxmenu gfxterm_background gfxterm_menu gfxterm loadenv configfile gzio part_gpt btrfs"

sed -i 's/#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' /etc/default/grub

grub-mkconfig -o /boot/grub/grub.cfg

sed -i 's/rootflags=subvol=${rootsubvol}//' /etc/grub.d/10_linux
sed -i 's/rootflags=subvol=${rootsubvol}//' /etc/grub.d/20_linux_xen
sed -i 's|,subvolid=258,subvol=/@/.snapshots/1/snapshot| |' /etc/fstab
