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
    unprivileged = true #needed if nesting
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
        command = "../make play nginx.yml"    
    }

}
//*/

resource "proxmox_lxc" "bms" {
    target_node  = "pve"
    hostname     = "${var.host_name}.bms-devops.ru"
    ostemplate   = var.distro
    onboot       = true
    vmid         = var.vmid
    memory       = 2048
    cores        = 2
    start        = true
    unprivileged = true
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
        ip = "172.16.0.${var.vmid}/24"
        gw = "172.16.0.11"
        ip6 = "auto"
        
    }

    provisioner "local-exec" {
        command = "make -C $IAAC_ROOT play ${var.host_name}.yml"    
    }

}


