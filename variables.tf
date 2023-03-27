variable "datacenter" {
  description = "Datacenter id"
}

variable "datastore" {
  description = "Datastore name"
}

variable "vm_template" {
  description = "Template name"
}

variable "name" {
  description = "VM name"
}

variable "network" {
  description = "VM Network"
}

variable "cpus" {
  default = "2"
}

variable "memory" {
  default = "2048"
}

variable "disk_size" {
  default = "120"
}

variable "public_key" {
  description = "Public key file path"
}

variable "user_data" {
  description = "userdata"
  default     = ""
}

variable "user_data_variables" {
  description = "userdata variables"
  default     = {}
}

variable "ipv4_address" {
  description = "ip address for vm network"
  default     = null
}

variable "ipv4_netmask" {
  description = "netmask for vm network"
  default     = null
}

variable "ipv4_gateway" {
  description = "gateway for vm network"
  default     = null
}

variable "dhcp" {
  description = "enable dhcp"
  default     = true
}

variable "domain" {
  description = "search domain"
  default     = ""
}