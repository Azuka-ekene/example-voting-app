variable "region" {
  description = "AWS region to build in"
  type        = string
  default     = "eu-west-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "voting-app-cluster"
}

variable "kubernetes_version" {
  description = "Kubernetes version (must be in EKS standard support)"
  type        = string
  default     = "1.34"
}

variable "node_instance_type" {
  description = "EC2 instance type for the worker nodes"
  type        = string
  default     = "t3.small"
}

variable "node_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 2
}