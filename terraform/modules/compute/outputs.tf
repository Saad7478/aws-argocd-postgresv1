output "kube_public_ip" {
  value = aws_instance.kube.public_ip
}

output "kube_instance_id" {
  value = aws_instance.kube.id
}