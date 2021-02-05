# Cloud Pak Platform Navigator



## Software dependencies

The module depends on the following software components:

### Command-line tools

- terraform - v12
- kubectl

### Terraform providers

- IBM Cloud provider >= 1.5.3
- Helm provider >= 1.1.1 (provided by Terraform)

## Module dependencies

This module makes use of the output from other modules:

- Cluster - github.com/ibm-garage-cloud/terraform-ibm-container-platform.git
- Namespace - github.com/ibm-garage-clout/terraform-cluster-namespace.git

## Example usage

```hcl-terraform
module "platform-navigator" {
  source = "github.com/ibm-garage-cloud/terraform-ibm-cp-platform-navigator.git"

  catalog_name        = module.cp4i.name
  cluster_type        = module.dev_cluster.type_code
  cluster_config_file = module.dev_cluster.config_file_path
  namespace           = module.dev_capture_tools_state.namespace
}
```
