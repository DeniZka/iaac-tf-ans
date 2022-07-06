//now empyt :)

output "id" {
    value = "${proxmox_lxc.bms.*.vmid}"
}
