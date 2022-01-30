#!/usr/bin/env bash
# This script will ask users about their prefrences
# like timezone, keyboard layout,
# user name, password, etc.


    pacman-key --init
    pacman-key --populate archlinux
    pacman -Syy
    sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
    pacman -S --noconfirm btrfs-progs gptfdisk reflector rsync
    timedatectl set-ntp true
    echo -ne "
-------------------------------------------------------------------------
                    Updating Mirrorlist
-------------------------------------------------------------------------
"
    reflector --verbose -a 48 -c canada -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist

    clear

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# set up a config file
CONFIG_FILE=$SCRIPT_DIR/config.sh

# set options in config.sh
set_option() {
    if grep -Eq "^${1}.*" $CONFIG_FILE; then # check if option exists
        sed -i -e "/^${1}.*/d" $CONFIG_FILE # delete option if exists
    fi
    echo "${1}=${2}" >>$CONFIG_FILE # add option
}
source /archscript/config.sh


timezone () {
# Added this from arch wiki https://wiki.archlinux.org/title/System_time
time_zone="$(curl --fail https://ipapi.co/timezone)"
echo -ne "
System detected your timezone to be '$time_zone' \n"
echo -ne "Is this correct?
"
options=("Yes" "No")
select_option $? 1 "${options[@]}"

case ${options[$?]} in
    y|Y|yes|Yes|YES)
    echo "${time_zone} set as timezone"
    set_option TIMEZONE $time_zone;;
    n|N|no|NO|No)
    echo "Please enter your desired timezone e.g. Europe/London :"
    read new_timezone
    echo "${new_timezone} set as timezone"
    set_option TIMEZONE $new_timezone;;
    *) echo "Wrong option. Try again";timezone;;
esac
}

keymap () {
echo -ne "
Please select key board layout from this list"
# These are default key maps as presented in official arch repo archinstall
options=(by ca cf cz de dk es et fa fi fr gr hu il it lt lv mk nl no pl ro ru sg ua uk us)

select_option $? 4 "${options[@]}"
keymap=${options[$?]}

echo -ne "Your key boards layout: ${keymap} \n"
set_option KEYMAP $keymap
loadkeys $keymap
}

userinfo () {
read -p "Please enter your username: " username
set_option USERNAME ${username,,} # convert to lower case as in issue #109
while true; do
  echo -ne "Please enter your password: \n"
  read -s password # read password without echo

  echo -ne "Please repeat your password: \n"
  read -s password2 # read password without echo

  if [ "$password" = "$password2" ]; then
    set_option PASSWORD $password
    break
  else
    echo -e "\nPasswords do not match. Please try again. \n"
  fi
done
while true; do
  echo -ne "Please enter your root password: \n"
  read -s rootpassword # read password without echo

  echo -ne "Please repeat your root password: \n"
  read -s rootpassword2 # read password without echo

  if [ "$rootpassword" = "$rootpassword2" ]; then
    set_option ROOTPASSWORD $rootpassword
    break
  else
    echo -e "\nPasswords do not match. Please try again. \n"
  fi
done
read -rep "Please enter your hostname: " nameofmachine
set_option NAME_OF_MACHINE $nameofmachine
}

efiformat () {

        #choice for formmating the EFI


        echo -ne "Do you want to format the EFI partition ? ${partition2}
    Choose No if it's already used by another system or Yes if it's a New partition"
    options=("Yes" "No")
    select_option $? 1 "${options[@]}"

    case ${options[$?]} in
        y|Y|yes|Yes|YES)
        echo "EFI partition will be Formatted"
        mkfs.vfat -F32 ${partition2};;
        n|N|no|NO|No)
        echo "Please make sure it's a valid EFI partition otherwise the following may fail"
        read -p "Press any key to resume";;
        *) echo "Wrong option. Try again";efiformat;;
    esac
}

swappartition () {

        #choice for Having Swap or not


        echo -ne "Do you have a Swap partition ?"
    
    options=("Yes" "No")
    select_option $? 1 "${options[@]}"

    case ${options[$?]} in
        y|Y|yes|Yes|YES)
        lsblk
        read -p "Please enter your SWAP partition (EX: /dev/sda2): " partition4
        mkswap ${partition4}
        uuid4="$(lsblk ${partition4} -no UUID)"
        swapon UUID="${uuid4}";;
        n|N|no|NO|No)
        echo "No Swap Partition are gonna be used"
        read -p "Press any key to resume";;
        *) echo "Wrong option. Try again";swappartition;;
    esac
}






homefinal () {
clear
logo
set_option HOMEPART "yes"
set_option HOMEDEV $partition5
}


homeformat () {

        #choice for Home Filesystem

        echo -ne "Do you want Btrfs or Ext4 For Home ?"
    
    options=("Btrfs" "Ext4")
    select_option $? 1 "${options[@]}"

    case ${options[$?]} in
        btrfs|Btrfs|BTRFS|b|B)
        mkfs.btrfs -L HOME -m single ${partition5} -f
        homefinal;;
        ext4|Ext4|EXT4|e|E)
        mkfs.ext4 -L HOME ${partition5}
        homefinal;;
        *) echo "Wrong option. Try again";homeformat;;
    esac
}

homepartition2 () {
        

        #choice for Formatting Home or Not
        logo
        lsblk
        read -p "Please enter your Home partition (EX: /dev/sda4): " partition5
        echo -ne "Do you want to format Home ?"
    
    options=("Yes" "No")
    select_option $? 1 "${options[@]}"

    case ${options[$?]} in
        y|Y|yes|Yes|YES)
        homeformat;;
        n|N|no|NO|No)
        echo "Home Partition is gonna be used as is"
        read -p "Press any key to resume"
        homefinal;;
        *) echo "Wrong option. Try again";homepartition2;;
    esac
}

homepartition () {

        #choice for Having Separate Home or Not


        echo -ne "Do you want a separate Home partition ?"
    
    options=("Yes" "No")
    select_option $? 1 "${options[@]}"

    case ${options[$?]} in
        y|Y|yes|Yes|YES)
        clear
        homepartition2;;


        n|N|no|NO|No)
        clear
        echo "No Home Partition are gonna be used"
        read -p "Press any key to resume";;
        *) echo "Wrong option. Try again";homepartition;;
    esac
}


clear
logo
keymap
clear
logo
userinfo
clear
logo
timezone
