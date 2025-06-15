output "flux_public_key" {
  description = "Add this key to GitHub → Deploy keys (RW)"
  value       = module.tls_keys.public_key_openssh
}

output "kubeconfig" {
  description = "Kubeconfig for the freshly created Kind cluster"
  value       = module.kind_cluster.kubeconfig
  sensitive   = true
}
