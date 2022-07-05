//
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

variable "vmid" {
    default = 100
    description = "SAME IP"
}

variable "host_name" {}

variable "memory" { default = 2048 }
variable "cores" { default = 2 }


