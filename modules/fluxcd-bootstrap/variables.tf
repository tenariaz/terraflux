# variable "github_repository" {
#   type        = string
#   description = "GitHub repository to store Flux manifests"
# }


variable "target_path" {
  type        = string
  default     = "clusters/dev"
  description = "Flux manifests subdirectory"
}

# variable "GITHUB_TOKEN" {
#   type        = string
#   description = "The token used to authenticate with the Git repository"
# }

# variable "repository_name" {
#   type        = string
#   description = "The Git repository"
# }

# variable "GITHUB_OWNER" {
#   type        = string
#   description = "The OWNER used to authenticate with the Git repository"
# }
# variable "private_key" {
#   type        = string
#   description = "The private key used to authenticate with the Git repository"
# }

# variable "kubeconfig" {
#   type        = string
#   default     = "~/.kube/config"
#   description = "The path to the kubeconfig file"
# }
