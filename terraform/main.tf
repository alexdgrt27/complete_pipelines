resource "aws_instance" "k8s_node" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.small"
  key_name      = data.aws_key_pair.lab_key.key_name

  vpc_security_group_ids = [
    data.aws_security_group.lab_sg.id
  ]

  tags = {
    Name = "k8s-node"
  }
}
