#!/bin/bash

#Adds the uname into the variable
uname= whoami

# Asks for dir and check if it exists. 
echo "Note: This will be in your home directory"
read -p "Enter the folder name of where the backups will be located: " backupdir

# Checks and creates dir if needed
[ ! -d $HOME/"$backupdir" ] && mkdir -p $HOME/"$backupdir"

echo
echo "Choose one of the following: "
echo "1 - Backup all VMs"
echo "2 - Backup a specific VM"
echo "3 - Close the program"
echo
read -p "Enter your choice: " ans

case $ans in
1)
    echo "Don't touch anything, even if it looks stuck."
	echo "You may risk corrupting your backup"
	echo
sudo -s <<EOF
	cd /var/lib/libvirt/images
	for g in *.qcow2; do
		echo "Backing up $g"
		name=$g
		final=$(basename $name .qcow2)
		gzip < $g > /home/$uname/$backupdir/$final.qcow2.backup.gz
		virsh dumpxml $final > /home/$uname/$backupdir/$final.xml
		done
EOF
    ;;

2)
sudo -s <<EOF
    cd /var/lib/libvirt/images
	echo
	virsh list --all
	echo
	read -p "Enter VM to backup: " vmbackup
	echo "Backing up $vmbackup"
	gzip < $vmbackup.qcow2 > /home/$uname/$backupdir/$vmbackup.qcow2.backup.gz
	virsh dumpxml $vmbackup > /home/$uname/$backupdir/$vmbackup.xml
EOF
    ;;

3|*)
    echo "Exiting program"
    exit 0
    ;;
esac
