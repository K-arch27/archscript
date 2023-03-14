# archscript
## My own arch install script with Btrfs and snapper Setup

### -----------Options Included-----------


Choice of Desktop environements/Tiling Manager

Choice of User Login Shell (bash, fish, zsh)

Choice of Aur helper/Pacman Frontend (yay, paru, octopi + yay, octopi + paru)

Choice for Multilib Repo

Choice for BlackArch Repo

Choice for Chaoctic-aur repo

Choice for Including /home or not inside of the main subvolume for snapshot

### -----------Important Information-----------

0: Pre-requisite
UEFI Only For now
Partition needs to be done before launching the script

KNOW BUG:
-When choosing a username or a password certain special characters will break the script

(For now I recommand entering a simple password and changing it after the installation if you want special charaters like @"' inside of it) 

### ------------Install Instruction------------

1: Boot on Arch Iso And partition your drive(s)

2: Get git on the iso : pacman -Sy git

3: Download the script : git clone https://github.com/K-arch27/archscript.git

4: Enter the directory of the script : cd archscript

5: Give the script permission to be executed : chmod +x ./start.sh

6: Launch it : ./start.sh

7: Make the choice that suit yourself when prompted

8: Sit back and enjoy


### ------------Troubleshooting------------

 sometimes there is a key problem with the Arch Iso and you have to do this before being able to install Git : 


> pacman -Sy archlinux-keyring

> pacman -Sy git

The git installation should now work
