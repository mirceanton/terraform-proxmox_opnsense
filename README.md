# Terraform Template: PVE opnSense

A Terraform template that deploys an opnSense VM on a Proxmox VE host.

## Requirements

- A Proxmox VE Host
- A machine with Hashicorp Terraform
- A network connection between the PVE host and the terraform machine
- An opnSense VM template on the PVE host

To create the VM template, take a look at this [packer template](https://github.com/mirceanton/packer-proxmox_opnsense).

## Getting Started

- Clone this repo
- Create a `.auto.tfvars` file and customize it
- Run the `terraform init` command
- Run the `terraform apply` command

### Variables

Here's an empty sample for the `.auto.tfvars` file, for you to customize:

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

## Advanced Usage

For a more advanced usage, see the `templates/` directory. Inside, there are some jinja2 templated versions of the same `.tf` files that allow for more granular customization.

They are intended to be formatted by an Ansible task, such as:

``` yml
- name: Provision an opnSense VM
  hosts: localhost
  become: true
  gather_facts: false

  vars:
    proxmox_url: "https://1.2.3.4:8006"
    proxmox_username: "root"
    proxmox_password: "test123"
    opnsense_vm_name: OPNsense
    opnsense_vm_target_node: pve01
    opnsense_pool_name: Networking
    opnsense_vm_id: 100
    opnsense_vm_clone: opnSense-tpl
    opnsense_vm_networks:
      - bridge: vmbr0 # WAN
      - bridge: vmbr1 # LAN
    opnsense_vm_disks:
      - size: 32G
        storage: local-zfs

  tasks:
    - name: Clone the terraform-proxmox_opnsense repo
      ansible.builtin.git:
        repo: https://github.com/mirceanton/terraform-proxmox_opnsense
        dest: /opt/terraform-proxmox_opnsense

    - name: Create template output directory
      ansible.builtin.file:
        path: /opt/terraform-proxmox_opnsense/template-output
        state: directory

    - name: Templatize provider file
      ansible.builtin.template:
        src: /opt/terraform-proxmox_opnsense/templates/provider.tf.j2
        dest: /opt/terraform-proxmox_opnsense/template-output/provider.tf

    - name: Templatize resource file
      ansible.builtin.template:
        src: /opt/terraform-proxmox_opnsense/templates/main.tf.j2
        dest: /opt/terraform-proxmox_opnsense/template-output/main.tf

    - name: Run Terraform
      community.general.terraform:
        project_path: /opt/terraform-proxmox_opnsense/template-output
        force_init: true
```

### Variables

For more details on certain variables, refer to the official module [documentation](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu).

``` yml
# Proxmox Connection Params
proxmox_api_url:                    # [Required] The URL for the Proxmox API endpoint
                                    # Format: https://a.b.c.d:8006/api2/json
pm_api_token_id:                    # [Required] The access token ID
pm_api_token_secret:                # [Required] The access token secret

# opnSense VM Params
opnsense_vm_name: opnSense          # [Optional] The name of the VM
opnsense_vm_target_node:            # [Required] The name of the node on which to deploy the VM
opnsense_vm_id: 100                 # [Optional] The ID of the VM
opnsense_vm_autoboot: true          # [Optional] Whether or not to start the VM on boot
opnsense_vm_clone: opnSense-tpl     # [Optional] The name of the VM to clone
opnsense_vm_cpu_type: host          # [Optional] The type of CPU to assign to the VM
opnsense_vm_cpu_cores: 2            # [Optional] The number of threads to assign to the VM
opnsense_vm_memory: 2048            # [Optional] The amount of RAM in mb to assign to the VM
opnsense_vm_scsihw: virtio-scsi-pci # [Optional] The type of SCSI hardware
opnsense_vm_bootdisk: scsi0         # [Optional] The name of the boot disk
opnsense_vm_boot_order: cdn         # [Optional] Device boot order (disk -> dvd -> network)
                                    # Options: floppy (a), hard disk (c), CD-ROM (d), or network (n).
opnsense_vm_vga_type: qxl           # [Optional] The type of VGA device.
                                    # Options: cirrus, none, qxl, qxl2, qxl3, qxl4, serial0, serial1, serial2, serial3, std, virtio, vmware.
opnsense_vm_vga_memory: 64          # [Optional] Sets the VGA memory (in MiB). Has no effect with serial display type.
opnsense_vm_disks:                  # [Required] List of disks to assign to the VM
  - type: scsi    # [Optional] The type of disk device to add.
                  # Options: ide, sata, scsi, virtio
    storage:      # [Required] The name of the storage pool on which to store the disk.
    size:         # [Required] The size of the created disk.
                  # Format must match the regex \d+[GMK], where G, M, and K represent Gigabytes, Megabytes, and Kilobytes respectively.
    backup: 1     # [Optional] Whether the drive should be included when making backups.
    iothread: 1   # [Optional] Whether to use iothreads for this drive.
    ssd: 1        # [Optional] Whether to expose this drive as an SSD, rather than a rotational hard disk.
opnsense_vm_networks:           # [Required] List of network devices
  - bridge:         # [Required] The name of the network bridge to attach to. (vmbr0, vmbr1 etc)
    firewall: true  # [Optional] Whether or not to 
    model: virtio   # [Optional] The NIC model
```

## License

MIT

## Author Information

A template developed by [Mircea-Pavel ANTON](https://www.mirceanton.com).
