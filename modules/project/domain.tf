
locals {
  _ad_domain         =  "syxxxxxxocal"
  _ad_netbios_domain = "SxxxxxxxA"
  _systema_dcs       = ["dcxxxxxx.syxxxxxxa.local", "dcxxxxxx.sxxxxxa.local"]
  _system_dcs        = ["dcxxxxxx.sxxxxx.local", "dcxxxxxx.sxxxxxx.local", "dcxxxxxx.sxxxxm.local", "dcxxxxxx.sxxxxx.local", "dcxxxxxx.xxxxx.local"]
  _ad_join_services = {
    "dev" : "https://adxxxxxxxx.cloud",
  }
  _ad_join_service = local._ad_join_services[local._platform_env]
}

output "ad_domain" {
  value = {
    "name" : local._ad_domain,
    "netbios" : local._ad_netbios_domain,
    "dcs" : local._systema_dcs,
    "ad_join_service" : local._ad_join_service
    "base_dn" :  "DC=syxxxxxxx,DC=lxxxxxxx"
  }
}
