#!/usr/bin/env bash
# Find the name of the folder the scripts are in
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
clear
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
    chmod +x ./1setup.sh
    chmod +x ./2partition.sh
    chmod +x ./3strap.sh
    chmod +x ./4chroot.sh
    chmod +x ./5final.sh
    cp -R ${SCRIPT_DIR} /
    mkdir ${SCRIPT_DIR}/log/
    ( bash /archscript/1setup.sh )|& tee ${SCRIPT_DIR}/log/startup.log
    source /archscript/setup.conf
    ( bash /archscript/2partition.sh )|& tee ${SCRIPT_DIR}/log/partition.log
    ( bash /archscript/3strap.sh )|& tee ${SCRIPT_DIR}/log/strap.log
    ( arch-chroot /mnt /root/archscript/4chroot.sh )|& tee ${SCRIPT_DIR}/log/chroot.log
    ( arch-chroot /mnt /root/archscript/5final.sh )|& tee ${SCRIPT_DIR}/log/final.log
    cp -R ${SCRIPT_DIR} mnt/home/$USERNAME/Desktop/logs
    touch mnt/home/$USERNAME/Desktop/logs/IMPORTANT.txt
    echo "please delete this folder and the one inside /root/archinstallscript , or move them to a secure location, since they contains trace of your installation (like your password and username) " > mnt/home/$USERNAME/Desktop/logs/IMPORTANT.txt
    
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
