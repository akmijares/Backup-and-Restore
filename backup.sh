#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run the script as sudo or root"
  exit 1
fi


#Adds the uname into the variable
echo "Note: You have to do this, otherwise, it'll default it to the root directory"
read -p "Enter username: " user

# Asks for dir and check if it exists. 
echo
echo "Note: This will be in your home directory"
read -p "Enter the folder name of where the backups will be located: " backupdir

# Checks and creates dir if needed
[ ! -d /home/$user/"$backupdir" ] && mkdir -p /home/$user/"$backupdir"

echo
echo "Choose one of the following: "
echo "1 - Backup all VMs"
echo "2 - Backup a specific VM"
echo "3 - Backup multiple VMs"
echo "4 - Close the program"
echo
read -p "Enter your choice: " ans

case $ans in

# Backup all VM
1)
    echo "Don't touch anything, even if it looks stuck."
	echo "You may risk corrupting your backup"
	echo
	for g in /var/lib/libvirt/images/*.qcow2;
	do
		echo "Backing up $g"
		name=$g
		final=$(basename $name .qcow2)
		gzip < $g > /home/$user/$backupdir/$final.qcow2.backup.gz
		virsh dumpxml $final > /home/$user/$backupdir/$final.xml
	done
    ;;

# Backup 1 vm
2)
	echo
	virsh list --all
	echo
	read -p "Enter the VM to backup: " vmbackup
	echo "Backing up $vmbackup"
	gzip < /var/lib/libvirt/images/$vmbackup.qcow2 > /home/$user/$backupdir/$vmbackup.qcow2.backup.gz
	virsh dumpxml $vmbackup > /home/$user/$backupdir/$vmbackup.xml
	echo "Backup of $vmbackup completed"
    ;;

# Backup multiple VM
3)
    read -p "How many VMs will you be backing up? " nums
    virsh list --all
    echo
    for i in $(seq 1 $nums);
    do
        read -p "Enter the VM to backup: " vmsback
	echo "Backing up $vmsback"
        gzip < /var/lib/libvirt/images/$vmsback.qcow2 > /home/$user/$backupdir/$vmsback.qcow2.backup.gz
        virsh dumpxml $vmsback > /home/$user/$backupdir/$vmsback.xml
        echo "Backup of $vmsback finished"
    done
    ;;

# Exit the program
4|*)
    echo "Exiting program"
    exit 0
    ;;
esac
