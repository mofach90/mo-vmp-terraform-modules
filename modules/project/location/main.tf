locals {
  region = var.region
  zone   = var.zone == null ? local.random_zone : var.zone
  zones  = local._zone_dict[var.region] 
  _zone_dict = merge(var.regions_eu_special, {
    for region in var.regions_eu_abc :
    region => ["${region}-a", "${region}-b", "${region}-c"]
  })
  random_zone = local.zones[0]
  backup_zone = local.zones[1]

}

resource "random_shuffle" "this" {
  input        = local._zone_dict[var.region]
  result_count = 3
}
