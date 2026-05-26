# -------------------
# Kubernetes Instance v
# -------------------

resource "aws_instance" "kube" {
  
  # You must accept the licence before using this ami
  # ami = "ami-02391db2758465a87"  # Rocky Linux 8
  ami = "ami-0e529d862bbe9899c"    # Rocky Linux 9

  instance_type = var.kube_instance_type
  
  availability_zone = var.public_azs[0]

  key_name = var.key_name

  subnet_id     = var.subnet_id

    vpc_security_group_ids = [
    var.kube_sg_id
  ]

  # Configuration du volume de boot (Root Volume)
  root_block_device {
    volume_type           = "gp3" # Optionnel : type de volume (ex: gp3, gp2)
    volume_size           = 10    # Optionnel : taille en Go
    delete_on_termination = true  # Optionnel : supprime le volume si l'instance est détruite

  }
}