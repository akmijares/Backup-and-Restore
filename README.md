# Backup-and-Restore
This is a backup and restore script that can be used to deal with .qcow2 files. 
It's setup so that anyone can use it whenever.

The [backup script](backup.sh) zips the .qcow2 files and dumps the xml files to the user specified directory.
The [restore script](restore.sh) unzips the compressed files and registers the xml files so that [libvirt](https://libvirt.org/manpages/libvirtd.html) can read and start the VM.

These scripts are based from [OPS235 Lab 2](https://wiki.cdot.senecacollege.ca/wiki/OPS235_Lab_2) where you would create VMs and prepare a backup/restore scenario.

# Note
While the backup script zips up the file, it will still be your responsibility to make sure those files are accessible (Cloud Storage, NAS, etc.) in the event that you would need to restore the VMs. I'd also advise to test the backup and restore of files to ensure that the script works properly.

When running the backup/restore, don't cancel/touch anything, even if it looks stuck. You could potentially corrupt the file itself and will need to restart. 

# How to run
1. Download the scripts or clone the repo (recommended)
2. Execute one of the scripts as sudo (recommended) or root
3. Follow the on-screen instructions

# License
This repo will be under the [MIT License](LICENSE)
