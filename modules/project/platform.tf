locals {
  _platform_available_projects = {
    "dev" : "mo-vm-plattform"
  }

  _env_short = {
    "dev" : "dev",
  }

  
  _platform_env          = try(var.workload.spec.environment, "dev")
  _platform_project      = local._platform_available_projects[local._platform_env]
  _platform_project_name = replace(local._platform_project, "/-[a-f0-9]+$/", "")
  _platfor_env_short     = local._env_short[local._platform_env]

  _is_platform_project = contains(values(local._platform_available_projects), local.project_id)

  # platform project numbers for service accounts of those projects
  _platform_project_numbers = {
    dev : "425661473129",
  }

  _artifacts_projects = {
    dev : {
      id : "mo-vm-plattform-artifacts",
      name : "mo-vm-plattform-artifacts",
      "number" : "644822199623"
    },
  }

  _platform_config = module.vmp_config.environments[local._platform_env]

  # map project id to platform config for workload_project_config
  _platform_configs = {
    for env, project_id in local._platform_available_projects : project_id => module.vmp_config.environments[env]
  }

  platform = {
    env                = local._platform_env
    env_short          = local._env_short
    projectId          = local._platform_project
    projectName        = local._platform_project_name
    projectNumber      = local._platform_config.platformProject.projectNumber
    project            = local._platform_config.platformProject
    config             = local._platform_config
    artifacts_projects = try(local._artifacts_projects[local._platform_env], null)
    project_numbers    = local._platform_project_numbers
  }
}

output "platform" {
  value = local.platform
}
