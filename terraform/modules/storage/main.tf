/*# S3 Backut
resource "aws_s3_bucket" "pgbackups2478" {
  bucket = "${var.name}-postgres-backups"
}
*/

# S3 Bucket pour les sauvegardes CloudNativePG (Barman)
resource "aws_s3_bucket" "postgres_backups" {
  bucket        = "${var.name}-postgres-backups"
  #force_destroy = false # Sécurité SRE : empêche la suppression accidentelle du bucket via Terraform s'il contient des sauvegardes
}