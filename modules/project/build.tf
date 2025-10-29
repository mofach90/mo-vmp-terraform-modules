locals {
  _registry_name = "${local.project.id}-docker"
  _registry_id   = "projects/${local.project.id}/locations/${local._primary_region}/repositories/${local._registry_name}"
  _registry_url  = "${local._primary_region}-docker.pkg.dev/${local.project.id}/${local._registry_name}"

  _bucket_name_build_artifacts = "${local.project.id}-build-artifacts"
  _bucket_name_build_logs      = "${local.project.id}-build-logs"
  _bucket_name_cloudbuild      = "${local.project.id}_cloudbuild"
}

output "build" {
  value = {
    docker_registry = {
      name         = local._registry_name
      id           = local._registry_id
      region       = local._primary_region
      registry_url = local._registry_url
    }
    build_artifacts_bucket = {
      name   = local._bucket_name_build_artifacts
      region = local._primary_region
    }
    build_logs_bucket = {
      name   = local._bucket_name_build_logs
      region = local._primary_region
    }
    cloudbuild_bucket = {
      name   = local._bucket_name_cloudbuild
      region = local._primary_region
    }
  }
}