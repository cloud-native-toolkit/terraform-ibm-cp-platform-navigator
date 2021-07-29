variable "catalog_name" {
  type        = string
  description = "The name of the Cloud Pak catalog"
  default     = "ibm-operator-catalog"
}

variable "cluster_type" {
  type        = string
  description = "The type of cluster"
  default     = "ocp4"
}

variable "cluster_config_file" {
  type        = string
  description = "The location of the kube config"
}

variable "namespace" {
  type        = string
  description = "The namespace where the platform navigator should be installed"
  default     = "cp4i"
}

variable "gitops_dir" {
  type        = string
  description = "The directory where the gitops configuration should be stored"
  default     = ""
}

variable "channel" {
  type        = string
  description = "The channel from which the Platform Navigator should be installed"
  default     = "v5.0"
}
