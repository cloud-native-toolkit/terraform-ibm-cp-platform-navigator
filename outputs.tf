output "name" {
  description = "Platform navigator instance name"
  value       = local.instance_name
  depends_on  = [null_resource.create_instance]
}

output "namespace" {
  description = "Platform navigator instance namespace"
  value       = var.namespace
  depends_on  = [null_resource.create_instance]
}
