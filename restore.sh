#!/bin/bash

#Add uname to variable
uname=$USER

# Asks for dir and check if it exists. 
echo "Note: This will look in your home directory. (Assuming you ran backup.sh)"
read -p "Enter the folder name of where the backups are located: " dir

if [ -d $HOME/$uname/"$dir" ]; then
	echo
	echo "Choose one of the following: "
	echo "1 - Restore all VMs"
	echo "2 - Restore a specific VM"
	echo "3 - Exit the program"
	echo
	read -p "Enter your choice: " ans
	case $ans in
	1)
        echo "Do not touch anything, even if it looks stuck."
		echo "You may risk corrupting the restore."
sudo -s <<EOF
		cd /home/$uname/$dir
		for g in *.qcow2.backup.gz; do
			name=$g
			final=$(basename $name .qcow2.backup.gz)
			gunzip < $g > /var/lib/libvirt/images/$final.qcow2
			virsh define $final.xml;
			done
EOF
        ;;
    
    2)
sudo -s <<EOF
        cd /home/$uname/$dir
		echo
		read -p "Enter VM to restore (No need to enter '.qcow2.backup.gz': " vmres
		echo "Restoring $vmres"
		gunzip < $vmres.qcow2.backup.gz > /var/lib/libvirt/images/$vmres.qcow2
		virsh define $vmres.xml
EOF
        ;;
    
    3|*)
        echo "Exiting program"
        ;;
	esac
else
    echo
	echo "$HOME/$uname/$dir does not exist. Please double check"
	exit 1
fi
