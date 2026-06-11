variable "name" {
  description = "Project name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "admin_cidr" {
  description = "Admin IP range allowed for SSH access"

  type = string
}

variable "bucket_s3_arn" {
  description = "Bucket S3 ARN"

  type = string
}
