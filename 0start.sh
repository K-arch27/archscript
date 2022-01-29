#!/usr/bin/env bash
# Find the name of the folder the scripts are in
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
clear
#mkdir /archscript
cp -R ${SCRIPT_DIR} /
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
    ( bash /archscript/1setup.sh )|& tee startup.log
    source /archscript/setup.conf
    ( bash /archscript/2partition.sh )|& tee partition.log
    ( bash /archscript/3strap.sh )|& tee strap.log
    ( arch-chroot /mnt /root/archscript/4chroot.sh )|& tee chroot.log
    ( arch-chroot /mnt /root/archscript/5final.sh )|& tee final.log
    
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
