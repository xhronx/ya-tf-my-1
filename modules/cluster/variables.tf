variable "managers" {
  description = "Count of manager nodes"
  type        = number
  default     = 2
}

variable "workers" {
  description = "Count of worker nodes"
  type        = number
  default     = 3
}

variable "instance_family_image" {
  description = "Instance image"
  type        = string
  default     = "ubuntu-2004-lts"
}

variable "vpc_subnet_id" {
  description = "VPC subnet network id"
  type        = string
}

variable "ssh_credentials" {
  description = "Credentials"
  type        = object({
    user        = string
    private_key = string
    pub_key     = string
  })
  default     = {
    user        = "ubuntu"
    private_key = "/home/xhronx/hronos@HOME-PC/id_rsa"
    pub_key     = "/home/xhronx/hronos@HOME-PC/id_rsa.pub"
  }
}
