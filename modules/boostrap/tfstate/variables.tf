module "config" {
  source      = "../../config/baseline"
  project_id  = var.workload_project_id
  region      = var.region
  environment = var.environment
}