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
