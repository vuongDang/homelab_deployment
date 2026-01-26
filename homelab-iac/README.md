# HomeLab

Configuration for my homelab with OpenTofu (Terraform) and Ansible. 
- `main.tf` for terraform install
- `playbook.yml` Ansible playbook to install Docker

## Steps 

1. Configure `terraform.tfvars` with your variables
2. Create proxmox LXC containers with OpenTofu 
3. Configure containers with Ansible

## Configure with your own variables 

Create a `terraform.tfvars` in the directory and fill the necessary variables

_terraform.tfvars template_
```
proxmox_api_url = "https://192.168.1.??:??/api2/json"
proxmox_user = "root@pam"
proxmox_password = ???
ssh_public_key = ???
docker_lab_password = ???
```


## Install and start OpenTofu from the controller machine  

Create LXC containers with OpenTofu. It will read the `main.tf`
file and prepare the LXC VM that will host all our docker applications.

```bash
tofu init
tofu plan
tofu apply
```

## Install Ansible and configure the containers

Will install dependencies and deploy our docker applications from the `playbook.yml`
- docker, docker-compose, apt-update
- deploy viva-padel server docker container
- deploy cloudflare tunnel docker container

```bash
ansible-playbook -i inventory.ini playbook.yml --ask-vault-pass -vv
```

NOTE: if you want to run the backend in test mode, comment the line  `CARGO_BUILD_FLAGS: "--no-default-features"`
