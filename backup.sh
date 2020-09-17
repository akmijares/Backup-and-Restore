#!/bin/bash

if [ $EUID != 0 ]; then
	echo "Please run as root or sudo"
	exit 1
fi

# Asks for uname
echo "This is required since you ran this as sudo/root"
read -p "Enter your username: " uname

if id "$uname" >/dev/null 2>&1; then
	echo "Found user. Continuing."
else
        echo "User does not exist. Please try again"
	exit 1
fi

# Asks for dir and check if it exists. 
echo ""
echo "Note: This will be in your home directory"
read -p "Enter the folder name of where the backups will be located: " backupdir

# Checks and creates dir if needed
[ ! -d /home/$uname/"$backupdir" ] && mkdir -p /home/$uname/"$backupdir"

echo
echo "Choose one of the following: "
echo "1 - Backup all VMs"
echo "2 - Backup a specific VM"
echo "3 - Close the program"
echo
read -p "Enter your choice: " ans
if [ "$ans" == 1 ]; then
	echo "Don't touch anything, even if it looks stuck."
	echo "You may risk corrupting your backup"
	cd /var/lib/libvirt/images
	for g in *.qcow2; do
		echo "Backing up $g"
		name=$g
		final=$(basename $name .qcow2)
		gzip < $g > /home/$uname/$backupdir/$final.qcow2.backup.gz
		virsh dumpxml $final > /home/$uname/$backupdir/$final.xml;
		done			
elif [ "$ans" == 2 ]; then
	cd /var/lib/libvirt/images
	echo
	read -p "Enter VM to backup: " vmbackup
	echo "Backing up $vmbackup"
	gzip < $vmbackup.qcow2 > /home/$uname/$backupdir/$vmbackup.qcow2.backup.gz
	virsh dumpxml $vmbackup > /home/$uname/$backupdir/$vmbackup.xml
elif [ "$ans" == 3 ]; then
	echo "Exiting program"
	exit 1
else
	echo "Unknown answer"
	exit 1
fi


