#!/usr/bin/env bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source $SCRIPT_DIR/config.sh

sed -i "s/^#${LANGLOCAL}/${LANGLOCAL}/" /etc/locale.gen
locale-gen


systemctl enable --now NetworkManager

# Add sudo rights
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers


#Add parallel downloading
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf

#Enable multilib
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf


#Installing some shit

pacman -Syu --needed --noconfirm nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader qemu-desktop libvirt edk2-ovmf virt-manager dnsmasq lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader go

systemctl enable libvirtd.service
systemctl enable virtlogd.socket
virsh net-autostart default

 groupadd libvirt
 useradd -m -G wheel,libvirt -s /bin/fish $USERNAME
        


# use chpasswd to enter $USERNAME:$password
echo "$USERNAME:$PASSWORD" | chpasswd
echo "root:$ROOTPASSWORD" | chpasswd

mkinitcpio -P

umount /.snapshots
rm -r /.snapshots
snapper --no-dbus -c root create-config /
btrfs subvolume delete /.snapshots
mkdir /.snapshots
mount -a
chmod 750 /.snapshots

clear
logo

      git clone https://github.com/k-arch27/dotfiles
      cp -a ./dotfiles/. /home/$USERNAME/.config/
      rm -Rfd ./dotfiles


 

clear
logo

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=K-Arch --modules="normal test efi_gop efi_uga search echo linux all_video gfxmenu gfxterm_background gfxterm_menu gfxterm loadenv configfile gzio part_gpt btrfs"

sed -i 's/#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' /etc/default/grub


sed -i 's/rootflags=subvol=${rootsubvol}//' /etc/grub.d/10_linux
sed -i 's/rootflags=subvol=${rootsubvol}//' /etc/grub.d/20_linux_xen
sed -i 's|,subvolid=258,subvol=/@/.snapshots/1/snapshot| |' /etc/fstab


grub-mkconfig -o /boot/grub/grub.cfg
