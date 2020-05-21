#!/bin/bash

if [ $EUID != 0 ]; then
	echo "Please run as root or sudo"
	exit 1
fi

echo "Backing up VMs"

cd /var/lib/libvirt/images


