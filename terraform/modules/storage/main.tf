# S3 Backut
resource "aws_s3_bucket" "pgbackups2478" {
  bucket = "${var.name}-postgres-backups"
}