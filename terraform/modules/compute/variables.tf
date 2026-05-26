variable "name" {
  description = "Project name"
  type        = string
}

# -------------------
# EC2
# -------------------

variable "kube_instance_type" {
  description = "KUBERNETES instance type"
  type        = string
}

variable "instance_profile_name" {
  description = "Instance profile name"

  type = string
}

# -------------------
# Networking
# -------------------

variable "subnet_id" {
  type        = string
  description = "ID du subnet fourni par le module réseau"
}

variable "kube_sg_id" {
  description = "KUBERNETES security group ID"

  type = string
}

variable "key_name" {
  type = string
}

variable "public_azs" {
  type = list(string)

  validation {
    condition     = length(var.public_azs) >= 1
    error_message = "Au moins 1 AZ sont nécessaires."
  }
}

# -------------------
# Tags
# -------------------

variable "tags" {
  description = "Common tags"

  type    = map(string)
  default = {}
}