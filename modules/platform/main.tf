locals {
  environments = ["dev"]

  platform_config_urls = {
    for env in local.environments : env => "https://raw.githubusercontent.com/mofach90/mo-vmp-config-/refs/heads/${urlencode(var.vmp_config_branch)}/data/platform/platform.yaml"
  }
  platform_config = {
    for env in local.environments : env => yamldecode(data.http.platform_config[env].response_body)
  }
}


data "http" "platform_config" {
  for_each = local.platform_config_urls
  url      = each.value
}

check "platform_config_status_code" {
  assert {
    condition = alltrue([
      for env in local.environments :
      data.http.platform_config[env].status_code == 200
    ])
    error_message = "Failed to read platform config as it returned an unhealthy status code"
  }
}

check "platform_config_content" {
  assert {
    condition = alltrue([
      for env in local.environments :
      try(yamldecode(data.http.platform_config[env].response_body)["kind"], "") == "PlatformConfig"
    ])
    error_message = "The platform configs found were not valid YAML files of kind \"PlatformConfig\""
  }
}
