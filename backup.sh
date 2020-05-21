#!/bin/bash

if [ $EUID != 0 ]; then
	echo "Please run as root or sudo"
	exit 1
fi

backupdir="/home/akmijares/backups"

# Checks and creates dir if needed
[ ! -d "$backupdir" ] && mkdir -p "$backupdir"

echo "Backing up VMs"
echo
echo "Do not touch anything, even if it looks stuck"

cd /var/lib/libvirt/images

for i in {1..3}; do
	echo
	echo "Backing up VM$i"
	gzip < vm$i.qcow2 > $backupdir/vm$i.qcow2.backup.gz
	virsh dumpxml vm1 > $backupdir/vm$i.xml
	echo "VM$i Backup completed"
	echo;
done

