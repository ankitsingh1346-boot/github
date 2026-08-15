variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}

variable "web_subnet_name" {
  description = "Name of the web subnet"
  type        = string
}

variable "app_subnet_name" {
  description = "Name of the app subnet"
  type        = string
}

variable "db_subnet_name" {
  description = "Name of the database subnet"
  type        = string
}

variable "web_subnet_prefix" {
  description = "CIDR for the web subnet"
  type        = string
}

variable "app_subnet_prefix" {
  description = "CIDR for the app subnet"
  type        = string
}

variable "db_subnet_prefix" {
  description = "CIDR for the database subnet"
  type        = string
}

variable "web_vm_name" {
  description = "Name of the web tier VM"
  type        = string
}

variable "app_vm_name" {
  description = "Name of the app tier VM"
  type        = string
}

variable "db_vm_name" {
  description = "Name of the data tier VM"
  type        = string
}

variable "vm_size" {
  description = "VM size for the Linux VMs"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the Linux VMs"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the Linux VMs"
  type        = string
}

variable "image_publisher" {
  description = "Publisher for the Linux image"
  type        = string
}

variable "image_offer" {
  description = "Offer for the Linux image"
  type        = string
}

variable "image_sku" {
  description = "SKU for the Linux image"
  type        = string
}

variable "image_version" {
  description = "Version for the Linux image"
  type        = string
}

variable "create_web_public_ip" {
  description = "Whether to create a public IP for the web VM"
  type        = bool
  default     = true
}

variable "web_public_ip_name" {
  description = "Name of the web public IP"
  type        = string
  default     = "pip-web-tier"
}
