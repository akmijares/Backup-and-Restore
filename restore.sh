#!/bin/bash

if [ $EUID != 0 ]; then
	echo "Please run as root or sudo"
	exit 1
fi

# Asks for dir and check if it exists. 
read -p "Enter full dir of where the backups are located: " dir

if [ -d "$dir" ]; then
	echo "Exists"
else
	echo "$dir does not exist. Please double check"
	exit 1
fi
