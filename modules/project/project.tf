locals {
    project_id = var.workload.spec.projectId
    project = {
    id   = local.project_id
    name = replace(local.project_id, "/-[a-f0-9]+$/", "")
  }
    project_full = merge(data.google_project.project, local.project)
}

data "google_project" "project" {
  project_id = local.project_id
  
}

output "project" {
    value = local.project_full
}