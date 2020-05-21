#!/bin/bash

if [ $EUID != 0 ]; then
	echo "Please run as root or sudo"
	exit 1
fi

# Asks for dir and check if it exists. 
read -p "Enter full dir of where the backups are located: " dir

if [ -d "$dir" ]; then
	echo
	echo "Choose one of the following: "
	echo "1 - Restore all VMs"
	echo "2 - Restore a specific VM"
	echo
	read -p "Enter your choice: " ans
	if [ "$ans" == 1 ]; then
		echo "1"
	elif [ "$ans" == 2 ]; then
		echo "2"
	else
		echo "Unknown answer"
		exit 1
	fi
else
	echo "$dir does not exist. Please double check"
	exit 1
fi
