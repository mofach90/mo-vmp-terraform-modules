module "project_config" {
  source            = "../project"
  vmp_config_branch = var.vmp_config_branch
  workload = {
    spec : {
      environment : var.environment
      projectId : var.project_id
      google : {
        location : {
          region : var.region
        }
      }
    }
  }
}