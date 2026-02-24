data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

data "aws_key_pair" "lab_key" {
  key_name = "devops-lab-key"
}

data "aws_security_group" "lab_sg" {
  name = "devops-lab-sg"
}
