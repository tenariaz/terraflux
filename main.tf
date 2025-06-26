terraform {
  required_providers {
    github = { source = "integrations/github", version = "6.6.0" }
    kind   = { source = "tehcyx/kind", version = "0.8.0" }
    flux   = { source = "fluxcd/flux", version = "1.6.1" }
    tls    = { source = "hashicorp/tls", version = "4.1.0" }
  }
}

provider "github" {
  owner = var.GITHUB_OWNER
  token = var.GITHUB_TOKEN
}

module "tls_keys" { source = "./modules/tls_keys" }

module "kind_cluster" {
  source       = "./modules/kind_cluster"
#  cluster_name = var.cluster_name

}

module "github_repository" {
  source                   = "./modules/github-repository"
  FLUX_GITHUB_REPO         = var.repository_name
  repository_visibility    = var.repository_visibility
  public_key_openssh       = module.tls_keys.public_key_openssh
  public_key_openssh_title = "flux-cluster-key"
  GITHUB_OWNER             = var.GITHUB_OWNER
  GITHUB_TOKEN             = var.GITHUB_TOKEN
}
# provider "kubernetes" {
#   config_path = module.kind_cluster.kubeconfig
# }
# resource "local_file" "kubeconfig" {
#   content  = module.kind_cluster.kubeconfig
#   filename = "./kubeconfig.yaml"
# }
provider "flux" {
  kubernetes = {
    config_path = "./kind-fluxcd-config"
  }
  git = {
    url = "https://github.com/${var.GITHUB_OWNER}/${var.repository_name}.git"
    http = {
      username = "git"
      password = var.GITHUB_TOKEN
    }
  }
}

module "fluxcd_bootstrap" {
  source            = "./modules/fluxcd_bootstrap/"
  github_repository = "${var.GITHUB_OWNER}/${var.repository_name}"
  private_key       = module.tls_keys.private_key_pem
  # config_host       = module.kind_cluster.endpoint
  # config_client_key = module.kind_cluster.client_key
  # config_ca         = module.kind_cluster.ca
  # config_crt        = module.kind_cluster.crt
  github_token      = var.GITHUB_TOKEN
  providers = {
    flux = flux
  }
}
