provider "github" {
  owner = var.GITHUB_OWNER
  token = var.GITHUB_TOKEN
}

resource "github_repository" "this" {
#  count      = var.create_repository ? 1 : 0
  name       = var.FLUX_GITHUB_REPO
  visibility = var.repository_visibility
  auto_init  = true
}

resource "github_repository_deploy_key" "this" {
  title      = var.public_key_openssh_title
  repository = github_repository.this.name
  key        = var.public_key_openssh
  read_only  = false
}
