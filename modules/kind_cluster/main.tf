resource "kind_cluster" "this" {
  name       = "kind-cluster-tf"
  wait_for_ready = true
}
