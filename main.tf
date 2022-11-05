resource "proxmox_vm_qemu" "opnsense" {
  # =============================================
  # GENERAL
  # =============================================
  name        = var.name
  target_node = var.target_node
  vmid        = var.vmid
  onboot      = var.auto_boot
  agent       = 0

  clone      = var.clone_name
  full_clone = true

  # =============================================
  # CPU
  # =============================================
  cpu   = "host"
  cores = var.cpu

  # =============================================
  # MEMORY
  # =============================================
  memory  = var.memory
  balloon = 0

  # =============================================
  # NETWORK
  # =============================================
  network { # LAN
    bridge   = var.lan_vmbridge
    firewall = false
    model    = "virtio"
  }
  network { # WAN
    bridge   = var.wan_vmbridge
    firewall = false
    model    = "virtio"
  }

  # =============================================
  # STORAGE
  # =============================================
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"
  boot     = "cdn"
  disk {
    type    = "scsi"
    size    = var.disk_size
    storage = var.disk_storage

    backup   = 1
    iothread = 1
    ssd      = 1
  }

  vga {
    type   = "qxl"
    memory = 64
  }
}
