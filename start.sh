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
    source /archscript/config.sh
    ( bash /archscript/1setup.sh )|& tee /archscript/setup.log
    ( bash /archscript/2partition.sh )|& tee /archscript/partition.log
    ( bash /archscript/3strap.sh )|& tee /archscript/strap.log
    ( arch-chroot /mnt /root/archscript/4chroot.sh )|& tee /mnt/root/archscript/chroot.log
    ( arch-chroot /mnt /root/archscript/5final.sh )|& tee /mnt/root/archscript/final.log
   
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
      Also note that this script copied itself in /root/archscript/
             with the config you choosed and the logs

"
