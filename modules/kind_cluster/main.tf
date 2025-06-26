resource "kind_cluster" "this" {
  name       = "kind-fluxcd"
  wait_for_ready = true
}
