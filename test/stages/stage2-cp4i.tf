module "cp4i" {
  source = "github.com/ibm-garage-cloud/terraform-ibm-cp-catalog"

  cluster_config_file = module.dev_cluster.config_file_path
  release_namespace   = module.dev_capture_tools_state.namespace
  entitlement_key     = var.entitlement_key
}
