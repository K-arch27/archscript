SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source /k-archscript/setup.conf
select_option() {

    # little helpers for terminal print control and key input
    ESC=$( printf "\033")
    cursor_blink_on()  { printf "$ESC[?25h"; }
    cursor_blink_off() { printf "$ESC[?25l"; }
    cursor_to()        { printf "$ESC[$1;${2:-1}H"; }
    print_option()     { printf "$2   $1 "; }
    print_selected()   { printf "$2  $ESC[7m $1 $ESC[27m"; }
    get_cursor_row()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
    get_cursor_col()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${COL#*[}; }
    key_input()         {
                        local key
                        IFS= read -rsn1 key 2>/dev/null >&2
                        if [[ $key = ""      ]]; then echo enter; fi;
                        if [[ $key = $'\x20' ]]; then echo space; fi;
                        if [[ $key = "k" ]]; then echo up; fi;
                        if [[ $key = "j" ]]; then echo down; fi;
                        if [[ $key = "h" ]]; then echo left; fi;
                        if [[ $key = "l" ]]; then echo right; fi;
                        if [[ $key = "a" ]]; then echo all; fi;
                        if [[ $key = "n" ]]; then echo none; fi;
                        if [[ $key = $'\x1b' ]]; then
                            read -rsn2 key
                            if [[ $key = [A || $key = k ]]; then echo up;    fi;
                            if [[ $key = [B || $key = j ]]; then echo down;  fi;
                            if [[ $key = [C || $key = l ]]; then echo right;  fi;
                            if [[ $key = [D || $key = h ]]; then echo left;  fi;
                        fi
    }
print_options_multicol() {
        # print options by overwriting the last lines
        local curr_col=$1
        local curr_row=$2
        local curr_idx=0

        local idx=0
        local row=0
        local col=0

        curr_idx=$(( $curr_col + $curr_row * $colmax ))

        for option in "${options[@]}"; do

            row=$(( $idx/$colmax ))
            col=$(( $idx - $row * $colmax ))

            cursor_to $(( $startrow + $row + 1)) $(( $offset * $col + 1))
            if [ $idx -eq $curr_idx ]; then
                print_selected "$option"
            else
                print_option "$option"
            fi
            ((idx++))
        done
    }

    # initially print empty new lines (scroll down if at bottom of screen)
    for opt; do printf "\n"; done

    # determine current screen position for overwriting the options
    local return_value=$1
    local lastrow=`get_cursor_row`
    local lastcol=`get_cursor_col`
    local startrow=$(($lastrow - $#))
    local startcol=1
    local lines=$( tput lines )
    local cols=$( tput cols )
    local colmax=$2
    local offset=$(( $cols / $colmax ))

    local size=$4
    shift 4

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local active_row=0
    local active_col=0
    while true; do
        print_options_multicol $active_col $active_row
        # user key control
        case `key_input` in
            enter)  break;;
            up)     ((active_row--));
                    if [ $active_row -lt 0 ]; then active_row=0; fi;;
            down)   ((active_row++));
                    if [ $active_row -ge $(( ${#options[@]} / $colmax ))  ]; then active_row=$(( ${#options[@]} / $colmax )); fi;;
            left)     ((active_col=$active_col - 1));
                    if [ $active_col -lt 0 ]; then active_col=0; fi;;
            right)     ((active_col=$active_col + 1));
                    if [ $active_col -ge $colmax ]; then active_col=$(( $colmax - 1 )) ; fi;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    return $(( $active_col + $active_row * $colmax ))
}






    clear
    lsblk
    read -p "Please enter your EFI partition (EX: /dev/sda1): " partition2
    read -p "Please enter your SWAP partition (EX: /dev/sda2): " partition4
    read -p "Please enter your Root partition : (EX: /dev/sda3 ) " partition3
    read -p "Please enter your Home partition : (EX: /dev/sda4 ) " partition5

    mkswap ${partition4}

    clear

efiformat () {

        #choice for formmating the EFI


        echo -ne "Do you want to format the EFI partition ? ${partition2}
    "
    options=("Yes" "No")
    select_option $? 1 "${options[@]}"

    case ${options[$?]} in
        y|Y|yes|Yes|YES)
        echo "EFI partition Formatted"
        mkfs.vfat -F32 ${partition2};;
        n|N|no|NO|No)
        echo "Please make sure it's a valid EFI partition otherwise the following may fail";;
        *) echo "Wrong option. Try again";efiformat;;
    esac
}
    efiformat

    mkfs.btrfs -L ROOT -m single ${partition3} -f
    mkfs.btrfs -L HOME -m single ${partition5} -f
    uuid2=$(lsblk ${partition2} -no UUID)
    uuid4=$(lsblk ${partition4} -no UUID)
    uuid3=$(lsblk ${partition3} -no UUID)

    uuid5=$(lsblk ${partition5} -no UUID)



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




