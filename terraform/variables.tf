variable "ansible_controller_machine_type" {
  default = "n1-standard-4"
}

variable "base_image" {
  default = "rhel-7-v20181113"
}

variable "trusted_ip_ranges" {
  default = "0.0.0.0/0"
}

variable "subnetwork_cidr" {
  default = "10.164.0.0/20"
}
