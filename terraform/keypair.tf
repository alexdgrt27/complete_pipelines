resource "tls_private_key" "lab_key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "lab_key" {
  key_name   = "devops-lab-key"
  public_key = tls_private_key.lab_key.public_key_openssh
}
