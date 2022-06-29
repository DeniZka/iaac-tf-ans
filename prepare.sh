#!/usr/bin/bash

# prepare Proxmox connection environment variables
# set TOKEN_ID & TOKEN_SECRET
#echo "export PM_USER=\"username\"" >> ~/.zshrc
#echo "export PM_PASSWORD=\"secret\"" >> ~/.zshrc

#echo "export PM_API_TOKEN_ID=\"terraform-prov@pve!mytoken\"" >> ~/.zshrc
#echo "export PM_API_TOKEN_SECRET=\"secret\"" >> ~/.zshrc


echo "export ANSIBLE_INVENTORY=`pwd`/hosts" >> ~/.zshrc
