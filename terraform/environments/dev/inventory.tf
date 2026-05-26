resource "local_file" "ansible_inventory" {
  filename = "../../../ansible/inventories/dev/hosts.ini"

  content = templatefile("${path.module}/templates/hosts.tpl", {
    kube_ip = module.compute.kube_public_ip
    kube_id = module.compute.kube_instance_id
  })
}

resource "local_file" "ssh_config" {
  filename = pathexpand("~/.ssh/kube-lab-config")

  file_permission = "0600"

  content = templatefile("${path.module}/templates/ssh_config.tpl", {
    kube_ip = module.compute.kube_public_ip
  
  })
}

/*resource "local_file" "ansible_storage" {
  filename = "../../../ansible/inventories/dev/storage.ini"

  content = templatefile("${path.module}/templates/storage.tpl", {
    storage_device_id = module.storage.device_id
    
  })
}*/