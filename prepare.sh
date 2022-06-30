#!/usr/bin/bash

#-----setup start------------
#BEFORE RUN SETUP THESE
#set your  pve  api token
TID="terraform-prov@pve!mytoken"
TPWD="secret"

#set your username (SEEMS NOT NEEDED)
UNAME="username"
UPWD="secret"

#------setup done-------------



#check terraform plugin exists
PATH_TO_CHECK=~/.terraform.d/plugins/my.pc.local/telmate/proxmox/2.9.10/linux_amd64/
FILE_TO_CHECK="$PATH_TO_CHECK"/terraform-provider-proxmox_v2.9.10
if [[ -f "$FILE_TO_CHECK" ]]; then
  echo "proxmox file exists"
else
  echo "proxmox file not exists downloading"
  mkdir -p "$PATH_TO_CHECK"
  wget https://github.com/Telmate/terraform-provider-proxmox/releases/download/v2.9.10/terraform-provider-proxmox_2.9.10_linux_amd64.zip
  unzip terraform-provider-proxmox_2.9.10_linux_amd64.zip -d "$PATH_TO_CHECK"
  rm -rf terraform-provider-proxmox_2.9.10_linux_amd64.zip
fi



#most default shell rc
SHELLRC='.bashrc'
#swhitch to most beauty shell rc
if [[ "$SHELL" == *"zsh"* ]]
then
  SHELLRC='.zshrc'
fi

echo Your shell RC is $SHELLRC

#setup RC file
if ! grep -q "PM_USER" ~/$SHELLRC; then
  echo SKIP USER SET
  #echo "export PM_USER=\"$UNAME\"" >> ~/$SHELLRC
fi

if ! grep -q "PM_PASSWORD" ~/$SHELLRC; then
  echo SKIP PWD SET
  #echo "export PM_PASSWORD=\"$UPWD\"" >> ~/$SHELLRC
fi

if ! grep -q "PM_API_TOKEN_ID" ~/$SHELLRC; then
  echo Adding PVE API ID
  echo "export PM_API_TOKEN_ID='$TID'" >> ~/$SHELLRC
fi

if ! grep -q "PM_API_TOKEN_SECRET" ~/$SHELLRC; then
  echo Adding PVE API TOKEN
  echo "export PM_API_TOKEN_SECRET=\"$TPWD\"" >> ~/$SHELLRC
fi

#STUP ANSIBLE INVENTORY FILE TO LOCAL
if ! grep -q "ANSIBLE_INVENTORY" ~/$SHELLRC; then
  echo Adding ansible local inventory
  echo "export ANSIBLE_INVENTORY=`pwd`/hosts" >> ~/$SHELLRC
fi

echo Done
