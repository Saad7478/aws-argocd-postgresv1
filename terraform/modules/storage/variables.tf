variable "name" {
  type = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "public_azs" {
  type = list(string)

  validation {
    condition     = length(var.public_azs) >= 1
    error_message = "Au moins 1 AZ sont nécessaires."
  }
}
