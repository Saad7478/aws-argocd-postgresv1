variable "name" {
  type = string
}

variable "cidr" {
  type = string
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)

  validation {
    condition     = length(var.public_subnets) >= 1
    error_message = "At least 1 public subnets are required"
  }
}

variable "public_azs" {
  type = list(string)

  validation {
    condition     = length(var.public_azs) >= 1
    error_message = "Au moins 1 AZ sont nécessaires."
  }
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}