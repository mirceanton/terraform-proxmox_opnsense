Terraform Template: PVE opnSense
================================

A Terraform template that deploys an opnSense VM on a Proxmox VE host.

Requirements
------------

- A Proxmox VE Host
- A machine with Hashicorp Terraform
- A network connection between the PVE host and the terraform machine
- An opnSense VM template on the PVE host

To create the VM template, take a look at this [packer template](https://github.com/mirceanton/packer-proxmox_opnsense).

Getting Started
---------------

- Clone this repo
- Create a `.auto.tfvars` file and customize it
- Run the `terraform init` command
- Run the `terraform apply` command

Variables
---------

Here's an empty sample for the `.auto.pkrvars.hcl` file, for you to customize:

``` hcl
# =============================================
# PROXMOX CONNECTION
# =============================================
proxmox_api_url = ""
proxmox_api_token_id = ""
proxmox_api_token_secret = ""

# =============================================
# GENERAL
# =============================================
target_node = ""
vmid = ""
name = ""
clone_name = ""
auto_boot = ""

# =============================================
# Resources
# =============================================
cpu = ""
memory = ""

# =============================================
# Network
# =============================================
wan_vmbridge = ""
lan_vmbridge = ""

# =============================================
# Storage
# =============================================
disk_size = ""
disk_storage = ""
```

License
-------

MIT

Author Information
------------------

A template developed by [Mircea-Pavel ANTON](https://www.mirceanton.com).
