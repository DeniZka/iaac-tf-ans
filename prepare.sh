#!/usr/bin/bash

#-----setup start------------
#BEFORE RUN SETUP THESE
#set your  pve  api token
TID='terraform-prov@pve!mytoken'
TPWD="secret"

#------setup done-------------

echo 'Enter proxmox API token ID (blah-blah@pve!blah-blah)'
echo 'Press [Return] to skip'
read TID
echo 'Enter proxmox API token secret (too-hard-to-hack-hash-code)'
echo 'Press [Return] to skip'
read TPWD


#check terraform plugin exists
PATH_TO_CHECK=~/.terraform.d/plugins/my.pc.local/telmate/proxmox/2.9.10/linux_amd64/
FILE_TO_CHECK="$PATH_TO_CHECK"/terraform-provider-proxmox_v2.9.10
if [[ -f "$FILE_TO_CHECK" ]]; then
  echo "proxmox file exists skip"
else
  echo "proxmox file not exists downloading"
  mkdir -p "$PATH_TO_CHECK"
  wget https://github.com/Telmate/terraform-provider-proxmox/releases/download/v2.9.10/terraform-provider-proxmox_2.9.10_linux_amd64.zip
  unzip terraform-provider-proxmox_2.9.10_linux_amd64.zip -d "$PATH_TO_CHECK"
  rm -rf terraform-provider-proxmox_2.9.10_linux_amd64.zip
fi


echo exporting terraform and ansible configurationtions

#setup RC file
echo SKIP USER SET
#echo "export PM_USER=\"$UNAME\"" >> ~/$SHELLRC
echo SKIP PWD SET
#echo "export PM_PASSWORD=\"$UPWD\"" >> ~/$SHELLRC
if [ -z $TID ]; then
  echo skip pve api id
else
  echo Adding PVE API ID
  export PM_API_TOKEN_ID=$TID
fi
if [ -z $TPWD ]; then
  echo skip pve api secret
else
  echo Adding PVE API TOKEN
 export PM_API_TOKEN_SECRET=$TPWD
fi
echo Adding ansible local inventory
export ANSIBLE_INVENTORY=`pwd`/hosts
echo Adding andible ssh key accepting
export ANSIBLE_HOST_KEY_CHECKING=False


echo Done
