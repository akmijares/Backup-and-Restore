#!/bin/bash

if [ $EUID != 0 ]; then
	echo "Please run as root or sudo"
	exit 1
fi

# Asks for dir and check if it exists. 
echo "Note: This will look in your home directory."
read -p "Enter the folder name of where the backups are located: " dir

if [ -d $HOME/"$dir" ]; then
	echo
	echo "Choose one of the following: "
	echo "1 - Restore all VMs"
	echo "2 - Restore a specific VM"
	echo "3 - Exit the program"
	echo
	read -p "Enter your choice: " ans
	if [ "$ans" == 1 ]; then
		echo "Do not touch anything, even if it looks stuck."
		echo "You may risk corrupting the restore."
		cd $dir
		for g in *.qcow2.backup.gz; do
			name=$g
			final=$(basename $name .qcow2.backup.gz)
			gunzip < $g > /var/lib/libvirt/images/$final.qcow2
			virsh define $final.xml;
			done			
	elif [ "$ans" == 2 ]; then
		cd $dir
		echo
		read -p "Enter VM to restore: " vmres
		echo "Restoring $vmres"
		gunzip < $vmres.qcow2.backup.gz > /var/lib/libvirt/images/$vmres.qcow2
		virsh define $vmres.xml
	elif [ "$ans" == 3 ]; then
		echo "Exiting program"
		exit 1
	else
		echo "Unknown answer"
		exit 1
	fi
else
	echo "$dir does not exist. Please double check"
	exit 1
fi
