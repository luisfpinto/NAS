#!/bin/bash
#This cript will create a private place with a User and Password who exists
#Add pass and user who exists
PASS=""
USER=""
#User must exists and you can change the password instead using the same as using in the system.
printf "$PASS\n$PASS\n" | smbpasswd -a -s $USER
#Creating private directory and add permisions
sudo mkdir -p /home/shares/private
chmod 777 /home/shares/private
echo "[Private]" >> /etc/samba/smb.conf
echo  "comment = Private Storage" >> /etc/samba/smb.conf
echo  "path = /home/shares/private" >> /etc/samba/smb.conf
echo  "valid users = pi" >> /etc/samba/smb.conf 
echo  "read only = no" >> /etc/samba/smb.conf
#Restarting server
sudo service samba restart

