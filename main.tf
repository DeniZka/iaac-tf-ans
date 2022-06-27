terraform {
  required_providers {
    proxmox = {
      source  = "my.bender.local/telmate/proxmox"
#      source  = "telmate/proxmox"
      version = "2.9.10"
    }
  }
}

# Using proxmox from a vagrant e.g. https://github.com/rgl/proxmox-ve
provider "proxmox" {
    pm_tls_insecure = true
    pm_api_url = "https://bms-devops.ru:8006/api2/json"
    pm_api_token_id = "denis@pve!tf-denis"
    pm_api_token_secret = "63064c0a-ad7e-4453-90ef-bc25fed285eb"
    #pm_user = "denis@pve"
    #pm_password = "denis"

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
    hostname     = "deb-11"
    ostemplate   = "local-btrfs:vztmpl/debian-11-standard_11.3-1_amd64.tar.zst"
    onboot       = true
    vmid         = 104
    memory       = 2048
    cores        = 2

    #generate hash openssl passwd -6 <my_password>
    #now: useruser
    password     = "$6$5Gxkjto7LXjCQCgy$oX4nsM/mJYyrHTTPatXPWeEu.gGu8FCA5Nb8pq6NxkYlUp8IiY2W.Gy7pygr4kNIViy4V.vzoZ.x5X.JNOqiq/"

    # my home pc 
    # proxmox
    ssh_public_keys = <<-EOT
        ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCov2nf2nZcAIH+KlFgaCsTwwVdNASW3H9IFjC7+INVprIEWmIQ7kZEv47xhLqL5E+50ePJ+qTkr5AJ3gwVKOgGo9FYWOdO8ml7A5dtI+pF0bQapcIuEIT3wU55gAGVL1pwW2X9+sJXCxCKGZhgyGLK7qeZsAAK8ucm63QOisnErDPB3FkCyCrTPLW4cF0s+h9GezK7nZAlY9nY3Sb1kKGlOSNY9P33O8M9G1lQ7Hcc4hfxWcpS/49pVPStA+rEDjsG6NIa4dtXFLxfmJTTtDHDNAhfaoY4KFO3cdEXvuHHUjH2tZEL4HUqHKtUwr5n5Txyv3Fu4j5qt/DCgYJX2WQn85EgAguu9Nwh5gpB0cCD3+qGi4zo28dwKjrZ7MPzQaOiM8fySbwwpe+ABJVJDF5bk12gw0gp1kHYDrOS78Pmu8nSekeofox9tgVh82uufOVLP9Qm14sulzm1119P2EBs6O/ntIZYEDREAGsCoBiu5xgAlkwNx/1KT9q9uox6SS8= denis@ibook
        ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCcTpme3YYXzDKfcIHi9kPs88pRvatv+pwWstW1ia/PLyFbdrEoDDRZNuTTW2/5awsIaodW18j7ZmnRVKaICNJRdA21qU6uQcaUyf74qZHRVN06zYRYdyeVpfjaI3jRIwqT/f9t6GLCzFgxy36FWYHGUM1cYKWzIbPbLisQLiZTq3If1tKpO2qH1ybIlxIlKsHJKt87d8uLi+LYHq82uUJ3kQHGI9kulse9I1SiLbjeuJTZLb2LhxNrICE4YNZqN+DpavUOZ+6o1KYWE4Cyao2uzE0u00j3eGghmKvljWk5Q9OYtOkfaA/XYvAmFg16bSwj0TE4Q/iq0egPs0sonHgF root@pve
    EOT

    rootfs {
        storage = "local-btrfs"
        size = "8G"    
    }


    network {
        name = "eth0"
        bridge = "vmbr0"
        ip = "dhcp"
        #ip = "172.16.0.1/24"
        ip6 = "auto"
    }

    provisioner "local-exec" {
        command = "ansible-playbook -i ans-test provision.yml"
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


