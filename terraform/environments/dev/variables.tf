variable "name" {
  description = "Project name"
  type        = string
}


variable "aws_region" {
  description = "AWS region"
  type        = string
}


# -------------------
# Networking
# -------------------

variable "cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_azs" {
  type = list(string)

  validation {
    condition     = length(var.public_azs) >= 1
    error_message = "Au moins 1 AZ sont nécessaires."
  }
}


variable "public_subnets" {
  description = "Public subnet CIDRs"

  type = list(string)
}

# -------------------
# Security
# -------------------# -------------------

variable "admin_cidr" {
  description = "Admin IP allowed for SSH"

  type = string
}

# -------------------
# KUBERNETES instance type
# -------------------

variable "kube_instance_type" {
  description = "KUBERNETES instance type"
  type        = string
}

# -------------------
# Tags
# -------------------

variable "tags" {
  description = "Common tags"

  type = map(string)

  default = {}
}