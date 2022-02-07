# archscript
My own arch install script with Btrfs and snapper Setup

-----------Important Information-----------

0: Pre-requisite
Having an EFI partition (can be shared with windows , just say no when ask if you want to format it)

Having a Swap Partition (will make change in the future for it to be optionnal)

Having a root Partition 

Having a Home Partition (can be the same as Root but i don't recommend it, Will make change in the future for it to be optionnal)

------------Install Instruction------------

1: Boot on Arch Iso

2: pacman -Sy git 

( sometimes there is a key problem with the Arch Iso and you have to do those 4 command before being able to install Git : 

killall gpg-agent

rm -rf /etc/pacman.d/gnupg

pacman-key --init

pacman-key --populate archlinux

pacman -Sy git

It should work now )

3: git clone https://github.com/K-arch27/archscript.git

4: cd archscript

5: chmod +x ./start.sh

6: ./start.sh

Anwser the question when prompted

sit back and enjoy
