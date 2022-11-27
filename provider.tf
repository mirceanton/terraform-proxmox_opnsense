# ===============================================
# Terraform configuration
# ===============================================
terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.7.0"
    }
  }
}

# ===============================================
# Proxmox Provider Configuration
# ===============================================
provider "proxmox" {
  virtual_environment {
    endpoint = var.proxmox_api_url
    username = var.proxmox_api_token_id
    password = var.proxmox_api_token_secret
    insecure = true
  }
}

variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type      = string
  sensitive = true
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}
