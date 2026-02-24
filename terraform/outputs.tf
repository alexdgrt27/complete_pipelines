output "k8s_ip" {
  value = aws_instance.k8s_node.public_ip
}
