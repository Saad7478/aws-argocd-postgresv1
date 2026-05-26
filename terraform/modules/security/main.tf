# KUBERNETES SG
resource "aws_security_group" "kube_sg" {
  name        = "${var.name}-kube-sg"
  description = "Kubernetes security group"
  vpc_id      = var.vpc_id

  ingress {
  description = "Allow ping"
  from_port   = -1
  to_port     = -1
  protocol    = "icmp"
  cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "SSH"

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = [var.admin_cidr]
  }

  ingress {
    description = "SSH"

    from_port   = 30443
    to_port     = 30443
    protocol    = "tcp"

    cidr_blocks = [var.admin_cidr]
  }

  ingress {
    description = "PostgreSQL"

    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "PostgreSQL-30564"

    from_port = 30564
    to_port   = 30564
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-kube-sg"
  })
}

# -------------------------------------------------------------
# 1. IAM ROLE
# -------------------------------------------------------------
resource "aws_iam_role" "kube_profile_role" {
  name = "${var.name}-kube-profile-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy
resource "aws_iam_policy" "pgbackrest_s3" {
  name        = "${var.name}-pgbackrest-s3-policy"
  description = "Autorise pgBackRest a ecrire dans S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Resource = [var.bucket_s3_arn]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucketMultipartUploads",
          "s3:AbortMultipartUpload"
        ]
        Resource = ["${var.bucket_s3_arn}/*"]
      }
    ]
  })
}

# IAM attach role policy
resource "aws_iam_role_policy_attachment" "attach_pgbackrest" {
  role       = aws_iam_role.kube_profile_role.name
  policy_arn = aws_iam_policy.pgbackrest_s3.arn
}

# 5. Instance Profile
resource "aws_iam_instance_profile" "kube_profile" {
  name = "${var.name}-kube-instance-profile"
  role = aws_iam_role.kube_profile_role.name
}
