#!/usr/bin/bash
echo `pwd`

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

