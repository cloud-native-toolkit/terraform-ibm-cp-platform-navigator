module "platform-navigator" {
  source = "./module"

  catalog_name        = module.cp4i.name
  cluster_type        = module.dev_cluster.type_code
  cluster_config_file = module.dev_cluster.config_file_path
  namespace           = module.dev_capture_tools_state.namespace
}
