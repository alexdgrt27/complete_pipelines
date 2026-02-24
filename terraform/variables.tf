variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "key_name" {
  description = "Existing EC2 key pair name"
  type        = string
  default     = "devops-lab-key"
}

variable "security_group_name" {
  description = "Existing Security Group name"
  type        = string
  default     = "devops-lab-sg"
}
