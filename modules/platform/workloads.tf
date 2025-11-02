locals {

  workload_config_urls = {
    for env in local.environments : env => "https://raw.githubusercontent.com/mofach90/mo-vmp-config-/refs/heads/${urlencode(var.vmp_config_branch)}/data/workloads/workloads.yaml"
  }

  workloads = {
    for env in local.environments : env => yamldecode(data.http.workload_config[env].response_body).workloads
  }
}


data "http" "workload_config" {
  for_each = local.workload_config_urls
  url      = each.value
}

check "workload_config_status_code" {
  assert {
    condition = alltrue([
      for env in local.environments :
      data.http.workload_config[env].status_code == 200
    ])
    error_message = "Failed to read workload config as it returned an unhealthy status code"
  }
}

check "workload_config_content" {
  assert {
    condition = alltrue([
      for env in local.environments :
      try(yamldecode(data.http.workload_config[env].response_body)["kind"], "") == "WorkloadList"
    ])
    error_message = "The workload configs found were not valid YAML files of kind \"WorkloadList\""
  }
}
