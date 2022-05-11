# archscript
## My own arch install script with Btrfs and snapper Setup

### -----------Options Included-----------


Choice of Desktop environements/Tiling Manager

Choice of Shell (bash, fish, oil, zsh)

Choice of Aur helper (yay, paru, octopi + yay, octopi + paru)

Choice for BlackArch Repo

Chaoctic-aur repo is added for the installation of snap-pac-grub



### -----------Important Information-----------

0: Pre-requisite
Having an EFI partition (can be shared with windows , just say no when ask if you want to format it)

Having a root Partition 

SWAP and home are optionnal

### ------------Install Instruction------------

1: Boot on Arch Iso

2: $ pacman -Sy git 

3: $ git clone https://github.com/K-arch27/archscript.git

4: $ cd archscript

5: $ chmod +x ./start.sh

6: $ ./start.sh

7: Make the choice that suit yourself

8: Sit back and enjoy


### ------------Troubleshooting------------

 sometimes there is a key problem with the Arch Iso and you have to do this command before being able to install Git : 


> pacman -Sy archlinux-keyring

> pacman -Sy git

The git installation should now work
