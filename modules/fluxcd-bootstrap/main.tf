
resource "flux_bootstrap_git" "this" {
  provider = flux
  path     = var.target_path
}
