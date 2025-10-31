locals {
  _cloud_build_default_worker_pool_name = "${local.project.name}-default"
  _cloud_build_default_worker_pool_id   = "projects/${local.project_id}/locations/${local._primary_region}/workerPools/${local._cloud_build_default_worker_pool_name}"
}

output "cloud_build" {
  value = {
    default_worker_pool = {
      name = local._cloud_build_default_worker_pool_name
      id   = local._cloud_build_default_worker_pool_id
    }
  }
}
