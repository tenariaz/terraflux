# # provider "flux" {
# #   kubernetes = {
# #     config_path = var.config_path
# #   }
# #   git = {
# #     url = "https://github.com/${var.github_repository}.git"
# #     http = {
# #       username = "git"
# #       password = var.GITHUB_TOKEN
# #     }
# #   }
# # }

# # resource "flux_bootstrap_git" "this" {
# #   path = var.target_path
# #  }



# # modules/fluxcd-bootstrap/main.tf

# # terraform {
# #   required_providers {
# #     flux = {
# #       source = "fluxcd/flux"
# #       version = "1.6.1"
# #       configuration_aliases = [flux]
# #     }
# #   }
# # }

# provider "flux" {
#   kubernetes = {
#     config_path = var.kubeconfig
#   }

#   git = {
#     url = "https://github.com/${var.GITHUB_OWNER}/${var.repository_name}.git"
#     http = {
#       username = "git"
#       password = var.GITHUB_TOKEN
#     }
#   }
# }

# resource "flux_bootstrap_git" "this" {
#   path = var.target_path
# }
resource "flux_bootstrap_git" "this" {
  provider = flux
  path     = var.target_path
}
