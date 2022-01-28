# Find the name of the folder the scripts are in
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
clear
mkdir /k-archscript
cp -R ${SCRIPT_DIR} /k-archscript
echo -ne "
-------------------------------------------------------------------------
                 █████╗ ██████╗  ██████╗██╗  ██╗
                ██╔══██╗██╔══██╗██╔════╝██║  ██║
                ███████║██████╔╝██║     ███████║
                ██╔══██║██╔══██╗██║     ██╔══██║
                ██║  ██║██║  ██║╚██████╗██║  ██║
                ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝
-------------------------------------------------------------------------
        Automated Arch Linux Installer With Btrfs Snapshot
-------------------------------------------------------------------------

"
    ( bash /k-archscript/1setup.sh )|& tee startup.log
    source /k-archscript/setup.conf
    ( bash /k-archscript/2partition.sh )|& tee partition.log
    ( bash /k-archscript/3strap.sh )|& tee strap.log
    ( arch-chroot /mnt /root/k-archscript/4chroot.sh )|& tee chroot.log
    ( arch-chroot /mnt /root/k-archscript/5final.sh )|& tee chroot.log
    #( arch-chroot /mnt /usr/bin/runuser -u $USERNAME -- /home/$USERNAME/ArchTitus/2-user.sh )|& tee 2-user.log
    #( arch-chroot /mnt /root/ArchTitus/3-post-setup.sh )|& tee 3-post-setup.log
    cp *.log /mnt/root/k-archscript/*.log
echo -ne "
-------------------------------------------------------------------------
                 █████╗ ██████╗  ██████╗██╗  ██╗
                ██╔══██╗██╔══██╗██╔════╝██║  ██║
                ███████║██████╔╝██║     ███████║
                ██╔══██║██╔══██╗██║     ██╔══██║
                ██║  ██║██║  ██║╚██████╗██║  ██║
                ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝
-------------------------------------------------------------------------
        Automated Arch Linux Installer With Btrfs Snapshot
-------------------------------------------------------------------------
            Done - Please Eject Install Media and Reboot

"
#Launch /root/archscript/final.sh for the last part
