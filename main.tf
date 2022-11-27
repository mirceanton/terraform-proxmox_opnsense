resource "proxmox_virtual_environment_pool" "networking_services_pool" {
  pool_id = "networking"
}

resource "proxmox_virtual_environment_vm" "opnsense" {
  name        = var.name
  description = var.description

  node_name = var.target_node
  vm_id     = var.vmid
  on_boot   = var.auto_boot

  pool_id = proxmox_virtual_environment_pool.networking_services_pool.pool_id

  agent {
    enabled = false
  }

  clone {
    vm_id = var.clone_id
  }

  cpu {
    cores = var.cpu_cores
    type  = "host"
  }

  memory {
    dedicated = var.memory
  }

  # =============================================
  # NETWORK
  # =============================================
  network_device {
    bridge = var.lan_vmbridge
  }
  network_device {
    bridge = var.wan_vmbridge
  }

  # =============================================
  # STORAGE
  # =============================================
  disk {
    datastore_id = var.disk_storage
    interface    = "scsi0"
    size         = var.disk_size
  }

  vga {
    type   = "qxl"
    memory = 64
  }

  lifecycle {
    ignore_changes = [
      network_interface_names,
      ipv4_addresses,
      ipv6_addresses
    ]
  }
}
