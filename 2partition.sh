SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source /archscript/config.sh


    clear
    logo
    lsblk
    read -p "Please enter your EFI partition (EX: /dev/sda1): " partition2
    read -p "Please enter your SWAP partition (EX: /dev/sda2): " partition4
    read -p "Please enter your Root partition : (EX: /dev/sda3 ) " partition3
    read -p "Please enter your Home partition : (EX: /dev/sda4 ) " partition5

    mkswap ${partition4}

    clear
	logo
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
        echo "Please make sure it's a valid EFI partition otherwise the following may fail";;
        *) echo "Wrong option. Try again";efiformat;;
    esac
}

#Formating partition
    efiformat
    clear

    mkfs.btrfs -L ROOT -m single ${partition3} -f
    mkfs.btrfs -L HOME -m single ${partition5} -f
#Getting UUID of newly formated partition    
    uuid2=$(lsblk ${partition2} -no UUID)
    uuid4=$(lsblk ${partition4} -no UUID)
    uuid3=$(lsblk ${partition3} -no UUID)

    #uuid5=$(lsblk ${partition5} -no UUID) unused since it was giving out error when trying to mount home with uuid



    mount UUID=${uuid3} /mnt


    btrfs subvolume create /mnt/@
	btrfs subvolume create /mnt/@/.snapshots
	mkdir /mnt/@/.snapshots/1
	btrfs subvolume create /mnt/@/.snapshots/1/snapshot
	mkdir /mnt/@/boot
	btrfs subvolume create /mnt/@/boot/grub
	btrfs subvolume create /mnt/@/opt
	btrfs subvolume create /mnt/@/root
	btrfs subvolume create /mnt/@/srv
	btrfs subvolume create /mnt/@/tmp
	mkdir /mnt/@/usr
	btrfs subvolume create /mnt/@/usr/local
	mkdir /mnt/@/var
	btrfs subvolume create /mnt/@/var/cache
	btrfs subvolume create /mnt/@/var/log
	btrfs subvolume create /mnt/@/var/spool
	btrfs subvolume create /mnt/@/var/tmp
	cp info.xml /mnt/@/.snapshots/1/info.xml
    btrfs subvolume set-default $(btrfs subvolume list /mnt | grep "@/.snapshots/1/snapshot" | grep -oP '(?<=ID )[0-9]+') /mnt
	btrfs quota enable /mnt
	chattr +C /mnt/@/var/cache
	chattr +C /mnt/@/var/log
	chattr +C /mnt/@/var/spool
	chattr +C /mnt/@/var/tmp

# unmount root to remount with subvolume
    umount /mnt

# mount @ subvolume
    mount UUID=${uuid3} -o compress=zstd /mnt

# make directories home, .snapshots, var, tmp

	mkdir /mnt/.snapshots
	mkdir -p /mnt/boot/grub
	mkdir /mnt/opt
	mkdir /mnt/root
	mkdir /mnt/srv
	mkdir /mnt/tmp
	mkdir -p /mnt/usr/local
	mkdir -p /mnt/var/cache
	mkdir /mnt/var/log
	mkdir /mnt/var/spool
	mkdir /mnt/var/tmp
	mkdir /mnt/boot/ESP
	mkdir /mnt/home


# mount subvolumes and partition

    mount UUID=${uuid3} -o noatime,compress=zstd,ssd,commit=120,subvol=@/.snapshots /mnt/.snapshots
    mount UUID=${uuid3} -o noatime,compress=zstd,ssd,commit=120,subvol=@/boot/grub /mnt/boot/grub
    mount UUID=${uuid3} -o noatime,compress=zstd,ssd,commit=120,subvol=@/opt /mnt/opt
    mount UUID=${uuid3} -o noatime,compress=zstd,ssd,commit=120,subvol=@/root /mnt/root
    mount UUID=${uuid3} -o noatime,compress=zstd,ssd,commit=120,subvol=@/srv /mnt/srv
    mount UUID=${uuid3} -o noatime,compress=zstd,ssd,commit=120,subvol=@/tmp /mnt/tmp
    mount UUID=${uuid3} -o noatime,compress=zstd,ssd,commit=120,subvol=@/usr/local /mnt/usr/local
    mount UUID=${uuid3} -o noatime,ssd,commit=120,subvol=@/var/cache /mnt/var/cache
    mount UUID=${uuid3} -o noatime,ssd,commit=120,subvol=@/var/log,nodatacow /mnt/var/log
    mount UUID=${uuid3} -o noatime,ssd,commit=120,subvol=@/var/spool,nodatacow /mnt/var/spool
    mount UUID=${uuid3} -o noatime,ssd,commit=120,subvol=@/var/tmp,nodatacow /mnt/var/tmp
    mount UUID=${uuid2} /mnt/boot/ESP
    mount ${partition5} /mnt/home/
    swapon UUID=${uuid4}
	



