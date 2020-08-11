resource "aws_network_interface" "kops-master-nic" {
  subnet_id       = var.subnet
  private_ips     = ["10.0.0.50"]
  security_groups = [var.security_group]
}

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.kops-master-nic.id
  associate_with_private_ip = "10.0.0.50"
}

resource "aws_s3_bucket" "prod-k8s-state-store-bucket" {
  bucket = "ycc-prod-k8s-state-store"
  acl    = "private"

  tags = {
    Name        = "kops remote state store"
    Environment = "Prod"
  }
}

resource "aws_instance" "kops-master-instance" {
  ami               = "ami-0d359437d1756caa8"
  instance_type     = "t2.micro"
  availability_zone = "eu-central-1a"
  key_name          = "prod-access-key"
  iam_instance_profile   = aws_iam_instance_profile.kops-master-profile.name

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.kops-master-nic.id
  }

  provisioner "file" {
    source      = "${path.module}/configurations/create-cluster.sh"
    destination = "/tmp/create-cluster.sh"
  }

  provisioner "file" {
    source      = "${path.module}/configurations/install-plugins.sh"
    destination = "/tmp/install-plugins.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install-plugins.sh",
      "/tmp/install-plugins.sh",
    ]
  }

  tags = {
    Name = "kops-master"
  }
}
