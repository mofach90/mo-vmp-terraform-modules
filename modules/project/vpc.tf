locals {
  _platform_subnetworks = {
    "mo-vm-plattform" : "mo-vm-plattform-europe-west3",

  }

  _default_network_prefix = "mo"

  _vpc_network_prefix = split("-", local.project.name)[0]

  _vpc_network_name = local._vpc_network_prefix == local._default_network_prefix ? local.project.name : "${local.project.name}-g"


  _vpc_network = try(
    local.spec.vpc.name,
    local._vpc_network_name,
  )

  _vpc_subnetwork = try(
    local.spec.vpc.subnet,
    local._platform_subnetworks[local.project_id],
    local._vpc_available_subnets[0],
  )

  _vpc_available_subnets = try(
    flatten([
      for link in data.google_compute_network.this.subnetworks_self_links :
      local._vpc_network_prefix == local._default_network_prefix ?
      try(
        [
          regex("https:\\/\\/www.googleapis.com\\/compute\\/v1\\/projects\\/${local.project.id}\\/regions\\/${local.location.region}\\/subnetworks\\/(${local.project.name}-${local.location.region}-[a-f0-9]{4})", link)[0]
      ], []) :
      try(
        [
          regex("https:\\/\\/www.googleapis.com\\/compute\\/v1\\/projects\\/${local.project.id}\\/regions\\/${local.location.region}\\/subnetworks\\/(${local.project.name}-[a-z0-9]{5})", link)[0]
      ], [])
  ]), [])

  vpc = {
    network       = local._vpc_network
    network_id    = data.google_compute_network.this.id
    subnetwork    = local._vpc_subnetwork
    subnetwork_id = data.google_compute_subnetwork.subnet.id
    ip_cidr_range = data.google_compute_subnetwork.subnet.ip_cidr_range
    zone          = try(local.spec.network.vpc.zone, "non-prod")
  }
}

output "vpc" {
  value = local.vpc
}

data "google_compute_network" "this" {
  project = local.project.id
  name    = local._vpc_network
}

data "google_compute_subnetwork" "subnet" {
  project = local.project.id
  name    = local._vpc_subnetwork
  region  = local.location.region
}
