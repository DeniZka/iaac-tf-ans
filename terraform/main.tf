// this liine for my gedit @ denis
terraform {
  required_providers {
    proxmox = {
      source  = "registry.terraform.io/hashicorp/proxmox"
      version = ">=2.9.10"
    }
  }
}

provider "proxmox" {
    pm_tls_insecure = true
    pm_api_url = "https://bms-devops.ru:8006/api2/json"
    pm_log_enable = true
    pm_log_file = "terraform-plugin-proxmox.log"
    #pm_debug = true
    #pm_log_levels = {
    #    _default = "debug"
    #    _capturelog = ""
    #}

}

/*
module "nginx" {
    vmid = 100
    source = "./bms-devops"
    hostname = "nginx"
}
*/

module "db01" {
    vmid = 101 #same IP
    source = "./bms-devops"
    host_name = "db01"
    role = "mysql"
}

/*
module "db02" {
    vmid = 102 
    source = "./bms-devops"
    host_name = "db02"
}
*/
