# S3 Bucket for PostgreSQL Backup and WAL archiving
resource "aws_s3_bucket" "postgres_backups" {
  bucket        = "${var.name}-postgres-backups"
  force_destroy = true        # Just for test environment

  #lifecycle {
  #  prevent_destroy = true       # USe this in production ennvironment
  #}

}