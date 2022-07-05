//
resource "proxmox_lxc" "bms" {
    target_node  = "pve"
    hostname     = "${var.host_name}.bms-devops.ru"
    ostemplate   = var.distro
    onboot       = true
    vmid         = var.vmid
    memory       = var.memory
    cores        = var.cores
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
        ip = "172.16.0.${var.vmid}/24"
        gw = "172.16.0.11"
        ip6 = "auto"
        
    }

    provisioner "local-exec" {
        command = "make -C $IAAC_ROOT ans-check-and-play ${var.host_name}.yml ${var.vmid} ${var.role}"
        //command = "make -C $IAAC_ROOT play ${var.host_name}.yml"
    }

}


