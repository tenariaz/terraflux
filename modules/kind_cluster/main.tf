resource "kind_cluster" "this" {
  name       = "kind-flux"
  wait_for_ready = true
}
