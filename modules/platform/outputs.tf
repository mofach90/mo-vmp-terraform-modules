output "environments" {
  description = "Environment configuration from yaml files"
  value       = local.platform_config
}

output "environment_names" {
  description = "list of supported environments"
  value       = local.environments
}

output "workloads" {
  description = "workload list per environment"
  value       = local.workloads
}

output "environment_yamls" {
  description = "YAML format of environment config"
  value       = { for env in local.environments : env => data.http.platform_config[env].response_body }
}
output "workload_yamls" {
  description = "YAML format for workload list"
  value       = { for env in local.environments : env => data.http.workload_config[env].response_body }
}
