variable "GITHUB_OWNER" {
  description = "GitHub owner"
  type        = string
}

variable "GITHUB_TOKEN" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
}

variable "repository_name" {
  description = "Name of GitOps repository to create"
  type        = string
}

variable "repository_visibility" {
  description = "Visibility of the GitOps repository"
  type        = string
  default     = "private"
}

variable "cluster_name" {
  description = "Kind cluster name"
  type        = string
  default     = "kind-cluster-tf"
}

variable "target_path" {
  description = "Path in the Git repo where Flux manifests live"
  type        = string
  default     = "clusters/dev"
}
