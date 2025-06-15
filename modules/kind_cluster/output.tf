variable "cluster_name" {
  description = "Kind cluster name"
  type        = string
}

output "kubeconfig" {
  value = kind_cluster.this.kubeconfig
  sensitive = true
}

output "client_key" {
  value = kind_cluster.this.client_key
}

output "ca" {
  value = kind_cluster.this.cluster_ca_certificate
}

output "crt" {
  value = kind_cluster.this.client_certificate
}

output "endpoint" {
  value = kind_cluster.this.endpoint
}
