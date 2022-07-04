variable "pass" {
  type        = string
  default     = "$6$5Gxkjto7LXjCQCgy$oX4nsM/mJYyrHTTPatXPWeEu.gGu8FCA5Nb8pq6NxkYlUp8IiY2W.Gy7pygr4kNIViy4V.vzoZ.x5X.JNOqiq/"
  description = "borned by: openssl passwd -6 <my_password>. password: useruser"
}

variable "distro" {
  type        = string
  default     = "local-btrfs:vztmpl/debian-11-standard_11.3-1_amd64.tar.zst"
  description = "standard distro for every lxc"
}

terraform {
  required_providers {
    proxmox = {
      source  = "my.pc.local/telmate/proxmox"
      version = ">=2.9.10"
    }
  }
}

provider "proxmox" {
    pm_tls_insecure = true
    pm_api_url = "https://bms-devops.ru:8006/api2/json"
    pm_log_enable = true
    pm_log_file = "terraform-plugin-proxmox.log"
    pm_debug = true
    pm_log_levels = {
        _default = "debug"
        _capturelog = ""
    }

}
/*
resource "proxmox_lxc" "nginx" {
    target_node  = "pve"
    hostname     = "bms-devops.ru"
    ostemplate   = var.distro
    onboot       = true
    vmid         = 100
    memory       = 2048
    cores        = 2
    start        = true
    password     = var.pass
    ssh_public_keys = file("id_rsa.keys")

    #works much faster with this feature
    features {
        nesting = true 
    }

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
        command = "ansible-playbook $ANSIBLE_PLAYBOOK_DIR/nginx.yml"    
    }

}
//*/

resource "proxmox_lxc" "db01" {
    target_node  = "pve"
    hostname     = "db01.bms-devops.ru"
    ostemplate   = var.distro
    onboot       = true
    vmid         = 101
    memory       = 2048
    cores        = 2
    start        = true
    password     = var.pass
    ssh_public_keys = file("id_rsa.keys")

    #works much faster with this feature
    features {
        nesting = true 
    }

    rootfs {
        storage = "local-btrfs"
        size = "8G"    
    }

    network {
        name = "eth0"
        bridge = "vmbr0"
        #ip = "dhcp"
        ip = "172.16.0.101/24"
        gw = "172.16.0.11"
        ip6 = "auto"
        
    }
    #resolving by name
    #nameserver = "172.16.0.11"
    #searchdomain = "lan"

    provisioner "local-exec" {
        command = "ansible-playbook $ANSIBLE_PLAYBOOK_DIR/db01.yml"    
    }

}

