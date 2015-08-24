#!/bin/bash
#This cript will create a private place with a User and Password who exists
PASS=""
USER=""
#User must exists and you can change the password instead using the same as using in the system.
printf "$PASS\n$PASS\n" | smbpasswd -a -s $USER
