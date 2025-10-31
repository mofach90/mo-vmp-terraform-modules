locals {
  private_dns_zone_name         = "${replace(local.project.name, "/ps[ih]-\\w/", "plz-dns")}-private-g"
  public_domain_validation_zone = "${replace(local.project.name, "/ps[ih]-\\w/", "plz-dns")}-public-domain-validation-g"
}

data "google_dns_managed_zone" "internal" {
  project = local.project.id
  name    = local.private_dns_zone_name
}

data "google_dns_managed_zone" "domain_validation" {
  project = local.project.id
  name    = local.public_domain_validation_zone
}

output "dns" {
  value = {
    private_zone = {
      id       = data.google_dns_managed_zone.internal.id
      name     = data.google_dns_managed_zone.internal.name
      dns_name = data.google_dns_managed_zone.internal.dns_name
      domain   = trimsuffix(data.google_dns_managed_zone.internal.dns_name, ".")
    }
    domain_validation_zone = merge(data.google_dns_managed_zone.domain_validation, {
      domain = trimsuffix(data.google_dns_managed_zone.domain_validation.dns_name, ".")
    })
  }
}
