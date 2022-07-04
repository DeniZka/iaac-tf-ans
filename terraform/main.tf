terraform {
  required_providers {
    proxmox = {
      source  = "my.pc.local/telmate/proxmox"
#      source  = "telmate/proxmox"
      version = ">=2.9.10"
    }
  }
}

# Using proxmox from a vagrant e.g. https://github.com/rgl/proxmox-ve
# export PM_USER and PM_PASSWORD
# or
# export PM_API_TOKEN_ID and PM_API_TOKEN_SECRET
provider "proxmox" {
    pm_tls_insecure = true
    pm_api_url = "https://bms-devops.ru:8006/api2/json"
    #

    #due to errors enabling logging
    pm_log_enable = true
    pm_log_file = "terraform-plugin-proxmox.log"
    pm_debug = true
    pm_log_levels = {
        _default = "debug"
        _capturelog = ""
    }

}

resource "proxmox_lxc" "test-debian1" {
    target_node  = "pve"
    hostname     = "bms-devops.ru"
    ostemplate   = "local-btrfs:vztmpl/debian-11-standard_11.3-1_amd64.tar.zst"
    onboot       = true
    vmid         = 100
    memory       = 2048
    cores        = 2

    #startup
    start        = true
    #onboot       = true

    #generate hash openssl passwd -6 <my_password>
    #now: useruser
    password     = "$6$5Gxkjto7LXjCQCgy$oX4nsM/mJYyrHTTPatXPWeEu.gGu8FCA5Nb8pq6NxkYlUp8IiY2W.Gy7pygr4kNIViy4V.vzoZ.x5X.JNOqiq/"

    # de home pc 
    # proxmox
    # denis job pc
    ssh_public_keys = file("id_rsa.keys")

    rootfs {
        storage = "local-btrfs"
        size = "8G"    
    }

    network {
        name = "eth0"
        bridge = "vmbr0"
        #ip = "dhcp"
        ip = "172.16.0.100/24"
        gw = "172.16.0.11"
        ip6 = "auto"
        
    }
    #resolving by name
    #nameserver = "172.16.0.11"
    #searchdomain = "lan"

    provisioner "local-exec" {
        #command = "ansible nodes -m ping"
        #need to sleep a bit before machine available
        command = "ansible-playbook $ANSIBLE_PLAYBOOK_DIR/nginx.yml"
    
    }

}

#resource "proxmox_vm_qemu" "test-pool" {
#  #super important variables
#  name        = "VM-name"
#  target_node = "pve"
#  vmid = 100
#  #one of next super important variable
#    hotplug = 0
#  iso = "local-btrfs:iso/ubuntu-20.04.4-desktop-amd64.iso"
#  
#  desc = "just testing machine"
#  
#   
#  ### or for a Clone VM operation
#  # clone = "template to clone"
#
#  ### or for a PXE boot VM operation
#  # pxe = true
#  # boot = "net0;scsi0"
#  # agent = 0
#
#  disk {
#    type = "scsi"
#    size = "10G"
#    storage = "local-btrfs"
#  }
#
#
#    
#}


