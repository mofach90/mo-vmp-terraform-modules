locals {
  buckets = {
    tfstate    = "${local.project.id}-tfstate"
    artifacts  = local._bucket_name_build_artifacts
    build_logs = local._bucket_name_build_logs
    assets     = "${substr(local.project.id, 0, 59)}-vmp"
  }
}

output "buckets" {
  value = local.buckets
}