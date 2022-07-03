#!/usr/bin/bash

echo "Chekcing your public ssh key in terraform list"
if grep -q "`cat $HOME/.ssh/id_rsa.pub`" `pwd`/terraform/id_rsa.keys
then
    echo "Exists. Every thin fine. Go on."
else
    echo "Absent. Adding your key into keyring file"
    cat $HOME/.ssh/id_rsa.pub >> `pwd`/terraform/id_rsa.keys
fi
