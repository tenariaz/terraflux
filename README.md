# TerraFlux – local GitOps playground

This stack creates:

* a local **Kind** cluster
* a private GitHub repo for GitOps manifests
* a pair of SSH keys
* a fully‑bootstrapped **Flux v2**

## Prerequisites

* Terraform ≥ 1.6
* Docker (Kind)
* GitHub personal access token with `repo` scope

## Quick start

```bash
export TF_VAR_github_owner="YOUR_GH_USER_OR_ORG"
export TF_VAR_github_token="ghp_…"

terraform init
terraform apply -auto-approve
