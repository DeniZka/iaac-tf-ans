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

//*
module "nginx" {
    vmid = 100 # same as host IP
    source = "./bms-devops"
    host_name = "nginx"
    role = "nginx" #for ansible checker
}
//*/

//*
module "db01" {
    vmid = 101
    source = "./bms-devops"
    host_name = "db01"
    role = "mysql" 
}
//*/

//*
module "db02" {
    depends_on = [module.db01]
    vmid = 102 
    source = "./bms-devops"
    host_name = "db02"
    role = "mysql"     
}
//*/

//*
module "app" {
    #cause of uses mysql db and when replication is done
    depends_on = [module.db02] 
    
    vmid = 103
    source = "./bms-devops"
    host_name = "app"
    role = "wordpress"     
}
//*/

//*
module "gitlab" {
    vmid = 104
    source = "./bms-devops"
    host_name = "gitlab"
    role = "gitlab"     
}
//*/
