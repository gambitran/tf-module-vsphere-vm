variable "datacenter" {
  description = "Datacenter id"
}

variable "datastore" {
  description = "Datastore name"
}

variable "vm_template" {
  description = "Template name"
}

variable "vm_name" {
  description = "Virtual Machine name"
}

variable "network" {
  description = "VM Network"
}

variable "instance_count" {
  description = "Number of instances"
  default     = "1"
}

variable "cpus" {
  default = "1"
}

variable "memory" {
  default = "1024"
}

variable "user_data" {
  description = "Path to script"
  default     = ""
}

variable "user_variable" {
  description = "userdata variables"
  default     = {}
}
