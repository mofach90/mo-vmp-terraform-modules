locals {
  location = {
    region       = module.location_primary.region
    zone         = module.location_primary.zone
    backup_zone  = module.location_primary.backup_zone
    zones        = module.location_primary.zones
    short_region = replace(lower(module.location_primary.region), "/(?i)([a-z]{1,2})([a-z]+)-?/", "$${1}")

    multiregion = local._multiregion

    backup = {
      region       = module.location_backup.region
      zone         = module.location_backup.zone
      backup_zone  = module.location_backup.backup_zone
      zones        = module.location_backup.zones
      short_region = replace(lower(module.location_backup.region), "/(?i)([a-z]{1,2})([a-z]+)-?/", "$${1}")
    }

    all = {
      regions = [
        module.location_primary.region,
        module.location_backup.region
      ],
      zones = concat(module.location_primary.zones, module.location_backup.zones)
    }
  }

  _primary_region         = try(local.spec.location.region, "europe-west3")
  _multiregion            = try(local.spec.location.multiregion, "EU")
  _backup_region_fallback = local._primary_region == "europe-west1" ? "europe-west3" : "europe-west1"
  _backup_region          = try(local.spec.location.backup.region, local._backup_region_fallback)
}

module "location_primary" {
  source = "./modules/location"
  region = local._primary_region
  zone   = try(local.spec.location.zone, null)
}

module "location_backup" {
  source = "./modules/location"
  region = local._backup_region
  zone   = try(local.spec.location.backup.zone, null)
}

output "location" {
  value = local.location
}
