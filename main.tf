terraform {
  required_providers {
    github = { source = "integrations/github", version = "6.6.0" }
    kind   = { source = "tehcyx/kind", version = "0.9.0" }
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
  cluster_name = var.cluster_name
}

module "github_repository" {
  source                   = "./modules/github-repository"
  repository_name          = var.repository_name
  repository_visibility    = var.repository_visibility
  public_key_openssh       = module.tls_keys.public_key_openssh
  public_key_openssh_title = "flux-cluster-key"
  GITHUB_OWNER             = var.GITHUB_OWNER
  GITHUB_TOKEN             = var.GITHUB_TOKEN
}

module "fluxcd_bootstrap" {
  source            = "./modules/fluxcd-bootstrap"
  github_repository = "${var.GITHUB_OWNER}/${module.github_repository.name}"
  target_path       = "clusters/dev"
  private_key       = module.tls_keys.private_key_pem
  GITHUB_TOKEN      = var.GITHUB_TOKEN
  config_path       = module.kind_cluster.kubeconfig
  #depends_on        = [module.kind_cluster]
}
