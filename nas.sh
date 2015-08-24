#!/bin/bash
#This script will create a NAS with a public folder
sudo apt-get install samba samba-common-bin -y
sudo mkdir -p /home/shares/public
sed "s/#   security = user/security = user/" /etc/samba/smb.conf 
sed "250s/   read only = yes/read only = no/" /etc/samba/smb.conf
echo "[public]" >> /etc/samba/smb.conf 
echo "  comment = Public Storage" >> /etc/samba/smb.conf
echo "  path = /home/shares/public" >> /etc/samba/smb.conf
echo "  guest ok = Yes"
echo "  read only = no" >> /etc/samba/smb.conf
sudo service samba restart