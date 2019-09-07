#/bin/bash

###########################################################################################
#
# Created By : Yakir BST
# Purpose : Partition Managment With Fdisk - Create Partirion \ LVM \ Foramt FS \ Mont
# Date : Sat Aug 31 23:52:21 IDT 2019
# Version : 0.0.1
#
###########################################################################################

##### VARS ######

Disdk=""
PS3="Type What You Want To Do :"
##### FUNCS ######

f_create_partition(){

fdisk -u /dev/$Disk <<EOF
n
p
1

w
EOF
}

f_create_LVM(){

fdisk -u /dev/$Disk <<EOF
p

t
8e

w
EOF
}

f_remove_partition(){

fdisk /dev/$Dsik <<EOF
p
d

w
EOF
}

f_create_file_system(){
	
	read -p "type the disk you want to format (sda) : " Disk
	echo -e "select file system you want to use (Enter for Default ext4) :"
	select i in "" "ext4" "vfat" "XFS"
	do
		case $fs in
			"""") mkfs ext4 /dev/$Disk ;;
			"ext4") mkfs ext4 /dev/$Disk ;;
			"vfat") mkfs vfat /dev/$Disk ;;
			"XFS") mkfs XFS /dev/$Disk ;;
		esac
	done

}

f_mount(){

	read -p "Type the disk or folder you want to mount (full path) : " $Path
	mount $Path /mnt/$Path
	echo "DONE"
}

###### MAIN ########

echo "WITH THIS TOOL YOU CAN MANAGE YOUR DISK EASLY"
sleep 0.5 && lsblk
read -p "Type The Disk You Want To Use :" Disk

select i in "List Disks" "Create Partition" "Create LVM" "Remove Partition" "Create File System" "Mount Disk" "Exit"
do
	case $i in
		"List Disks") lsblk ;;
		"Create Partition") f_create_partition  ;;
		"Create LVM") f_create_LVM ;;
		"Remove Partition") f_remove_partition ;;
		"Create File System") f_create_file_system ;;
		"Mount Disk") Mount Disk ;;
		"Exit") exit ;;

	esac
done
