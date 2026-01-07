terraform {
    required_providers {
        proxmox = {
            source = "telmate/proxmox"
            version = "3.0.2-rc07"
        }
    }
}

variable "proxmox_api_url" {
  type = string
}
variable "proxmox_user" {
  type = string
}
variable "proxmox_password" {
  type = string
  sensitive = true  # This prevents it from showing up in logs
}
variable "ssh_public_key" {
  type = string
}
variable "docker_lab_password" {
  type = string
}
variable "docker_lab_ip" {
  type = string
}

provider "proxmox" {
  pm_api_url = var.proxmox_api_url
  pm_user = var.proxmox_user
  pm_password = var.proxmox_password
  pm_tls_insecure = true
}

resource "proxmox_lxc" "docker_lab" {
  target_node = "pve"
  hostname = "lab-docker"
  ostemplate = "local:vztmpl/ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst"
  password = var.docker_lab_password
  unprivileged = true
  cores = 4
  memory = 4096
  swap = 512
  start = true

  features {
    nesting = true
    keyctl = true
  }

  rootfs {
    storage = "local-lvm"
    size = "200G"
  }

  network {
    name = "eth0"
    bridge = "vmbr0"
    ip = "${var.docker_lab_ip}/24"
    gw = "192.168.1.1"
  }

  ssh_public_keys = var.ssh_public_key
}


# Generate "inventory.ini" file for Ansible
resource "local_file" "ansible_inventory" {
  filename = "./inventory.ini"
  content  = <<-EOT
    [proxmox_lxc]
    ${var.docker_lab_ip} ansible_user=root
  EOT
}
