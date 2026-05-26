output "kube_sg_id" {
  description = "kubernetes security group ID"
  value       = aws_security_group.kube_sg.id
}

output "kube_instance_profile_id" {
  description = "INSTANCE Profile Name"
  value       = aws_iam_instance_profile.kube_profile.id
}