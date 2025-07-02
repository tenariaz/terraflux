output "flux_public_key" {
  description = "Add this key to GitHub → Deploy keys (RW)"
  value       = module.tls_keys.public_key_openssh
}

output "kubeconfig" {
  description = "Kubeconfig for the freshly created Kind cluster"
  value       = module.kind_cluster.kubeconfig
  sensitive   = true
}
output "gke_get_credentials_command" {
  value       = module.gke_cluster.cluster.gke_get_credentials_command
  description = "Run this command to configure kubectl to connect to the cluster."
}

output "kms_keys" {
  value       = module.kms.keys.sops-key-flux
  description = "Map of key name => key self link."
}
