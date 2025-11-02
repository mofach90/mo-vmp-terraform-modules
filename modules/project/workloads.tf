locals {
  workload_projects       = module.vmp_config.workloads[local._platform_env]
  workload_project_config = try(local._platform_configs[local.project_id], local.workload_projects[local.project_id], {})
}

output "workload_projects" {
  description = "workload project map"
  value       = local.workload_projects
}

output "workload_project_config" {
  description = "workload configuration of vmp-config"
  value       = local.workload_project_config
}