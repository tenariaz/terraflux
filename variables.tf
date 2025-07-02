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

variable "target_path" {
  description = "Path in the Git repo where Flux manifests live"
  type        = string
  default     = "clusters/demo"
}

variable "FLUX_GITHUB_TARGET_PATH" {
  type        = string
  default     = "clusters"
  description = "Flux manifests subdirectory"
}

variable "GOOGLE_PROJECT" {
  type        = string
  description = "GCP project to use"
}
variable "GOOGLE_REGION" {
  type = string
  default = "us-central1-a"
  description = "GCP region to use"
}
