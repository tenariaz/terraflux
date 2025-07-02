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

module "gke_cluster" {
  source         = "./modules/gke_cluster"
  GOOGLE_REGION  = var.GOOGLE_REGION
  GOOGLE_PROJECT = var.GOOGLE_PROJECT
  GKE_NUM_NODES  = 2
}
module "gke-workload-identity" {
  source        = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  use_existing_k8s_sa = true
  name                = "kustomize-controller"
  namespace           = "flux-system"
  project_id          = var.GOOGLE_PROJECT
  cluster_name        = "main"
  location            = var.GOOGLE_REGION
  annotate_k8s_sa     = true
  roles               = ["roles/cloudkms.cryptoKeyEncrypterDecrypter"]
    module_depends_on = [
    module.fluxcd_bootstrap
  ]
}

module "kms" {
  source          = "github.com/tenariaz/terraform-google-kms"
  project_id      = var.GOOGLE_PROJECT
  keyring         = "sops-flux"
  location        = "global"
  keys            = ["sops-key-flux"]
  prevent_destroy = false
}


resource "null_resource" "cluster_credentials" {
  depends_on = [
    module.gke_cluster,
    module.fluxcd_bootstrap
  ]

  provisioner "local-exec" {
    command = <<EOF
      ${module.gke_cluster.cluster.gke_get_credentials_command}
    EOF
  }
}

resource "null_resource" "git_commit" {
  depends_on = [
    module.fluxcd_bootstrap,
    module.kms
  ]

  provisioner "local-exec" {
    command = <<EOF
      if [ -d ${var.repository_name} ]; then
        rm -rf ${var.repository_name}
      fi
      git clone ${module.github_repository.values.http_clone_url}
      ./sops -e -gcp-kms ${module.kms.keys.sops-key-flux} --encrypted-regex '^(token)$' secret.yaml > ./demo_app/demo/secret-enc.yaml
      cp -r demo_app/* ${var.repository_name}/${var.FLUX_GITHUB_TARGET_PATH}/
      cd ${var.repository_name}
      git add .
      git commit -m"Added all manifests"
      git push
      cd ..
      rm -rf ${var.repository_name}
    EOF
  }
}
