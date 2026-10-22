output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "region" {
  value = var.region
}

output "connect_command" {
  value = "aws eks update-kubeconfig --region ${var.region} --name ${aws_eks_cluster.this.name}"
}