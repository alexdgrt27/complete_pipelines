output "k8s_ip" {
  description = "Public IP of Kubernetes node"
  value       = aws_instance.k8s_node.public_ip
}
