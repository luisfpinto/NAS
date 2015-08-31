#!/bin/bash
#This script will create a NAS with a public folder

#Install Nas Server
sudo apt-get install samba samba-common-bin -y
#Install usbmount to automount usb drives
sudo apt-get install usbmount
#Creating public directory and add permisions
sudo mkdir -p /home/shares/public
chmod 777 /home/shares/public
#Configuring samba server
sed "s/#   security = user/security = user/" /etc/samba/smb.conf 
sed "250s/   read only = yes/read only = no/" /etc/samba/smb.conf
echo "[public]" >> /etc/samba/smb.conf 
echo "  comment = Public Storage" >> /etc/samba/smb.conf
echo "  path = /home/shares/public" >> /etc/samba/smb.conf
echo "  guest ok = yes"
echo "  read only = no" >> /etc/samba/smb.conf
#Configuring server to avoid showing user folder
sed -i -e '244,246s/^/;/' /etc/samba/smb.conf
sed -i -e '250s/^/;/' /etc/samba/smb.conf
sed -i -e '254s/^/;/' /etc/samba/smb.conf
sed -i -e '258s/^/;/' /etc/samba/smb.conf
sed -i -e '265s/^/;/' /etc/samba/smb.conf
#Configuring server to allow seeing symlinks
sed -i '56a#symlinks' /etc/samba/smb.conf
sed -i '57afollow symlinks = yes' /etc/samba/smb.conf
sed -i '58awide links = yes' /etc/samba/smb.conf
sed -i '59unix extensions = no' /etc/samba/smb.conf
#Create script to automount devices accordint to its name on /home/shares/public
echo "#!/bin/sh" >  /etc/usbmount/mount.d/01_create_label_symlink
echo "# This script creates the volume label symlink in /var/run/usbmount." >>  /etc/usbmount/mount.d/01_create_label_symlink
echo "# Copyright (C) 2014 Oliver Sauder" >>  /etc/usbmount/mount.d/01_create_label_symlink
echo "#"
echo "# This file is free software; the copyright holder gives unlimited" >>  /etc/usbmount/mount.d/01_create_label_symlink
echo "# permission to copy and/or distribute it, with or without" >>  /etc/usbmount/mount.d/01_create_label_symlink
echo "# modifications, as long as this notice is preserved." >>  /etc/usbmount/mount.d/01_create_label_symlink
echo "#" >>  /etc/usbmount/mount.d/01_create_label_symlink
echo "# This file is distributed in the hope that it will be useful," >>  /etc/usbmount/mount.d/01_create_label_symlink
echo "# but WITHOUT ANY WARRANTY, to the extent permitted by law; without" >>  /etc/usbmount/mount.d/01_create_label_symlink
echo "# even the implied warranty of MERCHANTABILITY or FITNESS FOR A" >>  /etc/usbmount/mount.d/01_create_label_symlink
echo "# PARTICULAR PURPOSE." >>  /etc/usbmount/mount.d/01_create_label_symlink
echo "#" >>  /etc/usbmount/mount.d/01_create_label_symlink
echo "set -e" >>  /etc/usbmount/mount.d/01_create_label_symlink
echo ""  >>  /etc/usbmount/mount.d/01_create_label_symlink
echo "# Exit if device or mountpoint is empty." >>  /etc/usbmount/mount.d/01_create_label_symlink
echo "test -z \"$UM_DEVICE\" && test -z \"$UM_MOUNTPOINT\" && exit 0" >>  /etc/usbmount/mount.d/01_create_label_symlink
echo " " >>  /etc/usbmount/mount.d/01_create_label_symlink
echo "# get volume label name" >>  /etc/usbmount/mount.d/01_create_label_symlink
echo "label=`blkid -s LABEL -o value $UM_DEVICE`" >>  /etc/usbmount/mount.d/01_create_label_symlink
echo ""  >>  /etc/usbmount/mount.d/01_create_label_symlink
echo "# If the symlink does not yet exist, create it." >>  /etc/usbmount/mount.d/01_create_label_symlink
echo "test -z $label || test -e \"/home/shares/public/$label\" || ln -sf \"$UM_MOUNTPOINT\" \"/home/shares/public/$label\"" >>  /etc/usbmount/mount.d/01_create_label_symlink
echo "" >>  /etc/usbmount/mount.d/01_create_label_symlink
echo "exit 0" >>  /etc/usbmount/mount.d/01_create_label_symlink
#Changin configuration file of usbmount
sed -i "17s#/var/run/usbmount/$name#/home/shares/public/$name#" etc/usbmount/mount.d/00_remove_model_symlink
sed -i "18s#/var/run/usbmount/$name#/home/shares/public/$name#" etc/usbmount/mount.d/00_remove_model_symlink
sed -i '19d' /etc/usbmount/mount.d/00_remove_model_symlink
#Restarting server
sudo service samba restart