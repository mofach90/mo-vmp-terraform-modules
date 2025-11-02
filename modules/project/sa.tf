locals {
  _saprefix = try(local.spec.serviceAccounts.prefix, null) == null ? "" : local.spec.serviceAccounts.prefix
  _prefix   = length(local._saprefix) == 0 ? local.project.name : local._saprefix
  # sa can only be 30 characters long
  # allow 5 characters for the sa name
  _prefix_short   = substr(local._prefix, 0, 30 - 6)
  _project_prefix = split("-", local.project.id)[0]

  sa = {
    prefix = local._prefix_short
    provision = {
      id     = "${local._prefix_short}-wlm"
      email  = "${local._prefix_short}-wlm@${local.project.id}.iam.gserviceaccount.com"
      member = "serviceAccount:${local._prefix_short}-wlm@${local.project.id}.iam.gserviceaccount.com"
    }
    build = {
      id     = "${local._prefix_short}-build"
      email  = "${local._prefix_short}-build@${local.project.id}.iam.gserviceaccount.com"
      member = "serviceAccount:${local._prefix_short}-build@${local.project.id}.iam.gserviceaccount.com"
    }
    deploy = {
      name   = "${local._project_prefix}-deploy-g"
      id     = "projects/${local.project_id}/serviceAccounts/${local._project_prefix}-deploy-g@${local.project.id}.iam.gserviceaccount.com"
      email  = "${local._project_prefix}-deploy-g@${local.project.id}.iam.gserviceaccount.com"
      member = "serviceAccount:${local._project_prefix}-deploy-g@${local.project.id}.iam.gserviceaccount.com"
    }
  }
}

output "sa" {
  value = local.sa
}
