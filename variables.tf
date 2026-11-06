variable "cloud_id" {
  type = string
}
variable "folder_id" {
  type = string
}
variable "service_account_key_file" {
  type    = string
  default = "~/.config/terraform-netology/authorized_key.json"
}
variable "default_zone" {
  type    = string
  default = "ru-central1-a"
}
variable "default_cidr" {
  type    = list(string)
  default = ["10.0.1.0/24"]
}
variable "vpc_name" {
  type    = string
  default = "develop"
}
variable "project_name" {
  type    = string
  default = "netology"
}
variable "environment" {
  type    = string
  default = "develop"
}
variable "ssh_allowed_cidrs" {
  type = list(string)
  validation {
    condition     = length(var.ssh_allowed_cidrs) > 0 && alltrue([for cidr in var.ssh_allowed_cidrs : can(cidrnetmask(cidr)) && cidr != "0.0.0.0/0"])
    error_message = "Укажите ограниченные IPv4 CIDR для SSH."
  }
}
variable "metadata" {
  type = map(object({
    serial_port_enable = number
    ssh_keys           = string
  }))
  validation {
    condition     = contains(keys(var.metadata), "common")
    error_message = "Необходим metadata.common."
  }
}
# Заменена metadata.common.ssh_keys; открытый ключ задаётся в terraform.tfvars.
# variable "vms_ssh_public_root_key" { type = string }
# variable "vms_ssh_root_key" { type = string }

variable "existing_network_id" {
  description = "Существующая сеть при исчерпанной квоте; null создаёт новую."
  type        = string
  default     = null
}
