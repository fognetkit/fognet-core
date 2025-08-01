locals {
  default_labels = {
    deployment_source = var.deployment_source
    project           = "fognet-core"
    managed_by        = "terraform"
  }
}