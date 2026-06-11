# Generates the Ansible inventory file from a template using the Kubernetes 
# instance IP address and instance ID output by the compute module.
resource "local_file" "ansible_inventory" {
  filename = "../../../ansible/inventories/dev/hosts.ini"

  content = templatefile("${path.module}/templates/hosts.tpl", {
    kube_ip = module.compute.kube_public_ip
    kube_id = module.compute.kube_instance_id
  })
}

# Generates an SSH configuration file for the Kubernetes instance 
# using its public IP address, enabling simplified and secure SSH access.
resource "local_file" "ssh_config" {
  filename = pathexpand("~/.ssh/kube-lab-config")

  file_permission = "0600"

  content = templatefile("${path.module}/templates/ssh_config.tpl", {
    kube_ip = module.compute.kube_public_ip
  
  })
}