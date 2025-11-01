locals {
  _kms_key_name      = try(local.spec.kms.key, local.project_id)
  _kms_ring_name     = try(local.spec.kms.keyRing, local.project_id)
  _kms_ring_location = try(local.spec.kms.location, local.location.region)
  _kms_key_link      = "projects/${local.project.id}/locations/${local._kms_ring_location}/keyRings/${local._kms_ring_name}/cryptoKeys/${local._kms_key_name}"

  _kms_backup_key_name      = try(local.spec.kms.backup.key, "${local._kms_key_name}-backup")
  _kms_backup_ring_name     = try(local.spec.kms.backup.keyRing, "${local._kms_ring_name}-backup")
  _kms_backup_ring_location = try(local.spec.kms.backup.location, local.location.backup.region)
  _kms_backup_key_link      = "projects/${local.project.id}/locations/${local._kms_backup_ring_location}/keyRings/${local._kms_backup_ring_name}/cryptoKeys/${local._kms_backup_key_name}"

  _kms_multiregion_key_name      = try(local.spec.kms.multiregion.key, "${local._kms_key_name}-multiregion")
  _kms_multiregion_ring_name     = try(local.spec.kms.multiregion.keyRing, "${local._kms_ring_name}-multiregion")
  _kms_multiregion_ring_location = try(local.spec.kms.multiregion.location, "europe")
  _kms_multiregion_key_link      = "projects/${local.project.id}/locations/${local._kms_multiregion_ring_location}/keyRings/${local._kms_multiregion_ring_name}/cryptoKeys/${local._kms_multiregion_key_name}"

  _vmp_keys = [
    local._kms_key_link,
    local._kms_backup_key_link,
    local._kms_multiregion_key_link,
  ]

  _vmp_kms = {
    keys = local._keys
    key = {
      name     = local._kms_key_name
      ring     = local._kms_ring_name
      location = local._kms_ring_location
      link     = local._kms_key_link

      backup = {
        name     = local._kms_backup_key_name
        ring     = local._kms_backup_ring_name
        location = local._kms_backup_ring_location
        link     = local._kms_backup_key_link
      }

      multiregion = {
        name     = local._kms_multiregion_key_name
        ring     = local._kms_multiregion_ring_name
        location = local._kms_multiregion_ring_location
        link     = local._kms_multiregion_key_link
      }
    }
  }

  _use_vmp_kms    = try(local.workload_project_config.vmpKmsUse, false)
  _vmp_kms_type   = try(local.workload_project_config.vmpKmsType, "hsm") != "" ? try(local.workload_project_config.vmpKmsType, "hsm") : "hsm"
  _create_vmp_kms = try(local.workload_project_config.vmpKmsCreate, false)
}

locals {
  _keys = concat(
    local._create_vmp_kms ? local._vmp_keys : [],
    !local._use_vmp_kms ? local._cse_keys : [],
  )

  _cse_kms_key_name      = "${local._vmp_kms_type}-project-key"
  _cse_kms_ring_name     = "cse-cmek-v1"
  _cse_kms_ring_location = try(local.spec.kms.location, local.location.region)
  _cse_kms_key_link      = "projects/${local.project.id}/locations/${local._cse_kms_ring_location}/keyRings/${local._cse_kms_ring_name}/cryptoKeys/${local._cse_kms_key_name}"

  _cse_kms_backup_key_name      = "${local._vmp_kms_type}-project-key"
  _cse_kms_backup_ring_name     = "cse-cmek-v1"
  _cse_kms_backup_ring_location = try(local.spec.kms.backup.location, local.location.backup.region)
  _cse_kms_backup_key_link      = "projects/${local.project.id}/locations/${local._cse_kms_backup_ring_location}/keyRings/${local._cse_kms_backup_ring_name}/cryptoKeys/${local._cse_kms_backup_key_name}"

  _cse_kms_multiregion_key_name      = "${local._vmp_kms_type}-project-key"
  _cse_kms_multiregion_ring_name     = "cse-cmek-v1"
  _cse_kms_multiregion_ring_location = try(local.spec.kms.multiregion.location, "europe")
  _cse_kms_multiregion_key_link      = "projects/${local.project.id}/locations/${local._cse_kms_multiregion_ring_location}/keyRings/${local._cse_kms_multiregion_ring_name}/cryptoKeys/${local._cse_kms_multiregion_key_name}"

  _cse_keys = [
    local._cse_kms_key_link,
    local._cse_kms_backup_key_link,
    local._cse_kms_multiregion_key_link,
  ]

  _cse_kms = {
    keys = local._keys
    key = {
      name     = local._cse_kms_key_name
      ring     = local._cse_kms_ring_name
      location = local._cse_kms_ring_location
      link     = local._cse_kms_key_link

      backup = {
        name     = local._cse_kms_backup_key_name
        ring     = local._cse_kms_backup_ring_name
        location = local._cse_kms_backup_ring_location
        link     = local._cse_kms_backup_key_link
      }

      multiregion = {
        name     = local._cse_kms_multiregion_key_name
        ring     = local._cse_kms_multiregion_ring_name
        location = local._cse_kms_multiregion_ring_location
        link     = local._cse_kms_multiregion_key_link
      }
    }
  }
}


locals {
  # These keys will be used to encrypt backups like snapshots
  _backup_keys = concat(
    local._create_vmp_kms ? local._vmp_keys : [],
    !local._use_vmp_kms ? local._cse_keys : [],
  )

  _backup_cse_kms_key_name      = "hsm-project-key-vmpbackup"
  _backup_cse_kms_ring_name     = "cse-cmek-v1"
  _backup_cse_kms_ring_location = try(local.spec.kms.location, local.location.region)
  _backup_cse_kms_key_link      = "projects/${local.project.id}/locations/${local._backup_cse_kms_ring_location}/keyRings/${local._backup_cse_kms_ring_name}/cryptoKeys/${local._backup_cse_kms_key_name}"

  _backup_cse_kms_backup_key_name      = "hsm-project-key-vmpbackup"
  _backup_cse_kms_backup_ring_name     = "cse-cmek-v1"
  _backup_cse_kms_backup_ring_location = try(local.spec.kms.backup.location, local.location.backup.region)
  _backup_cse_kms_backup_key_link      = "projects/${local.project.id}/locations/${local._cse_kms_backup_ring_location}/keyRings/${local._backup_cse_kms_backup_ring_name}/cryptoKeys/${local._backup_cse_kms_backup_key_name}"

  _backup_cse_kms_multiregion_key_name      = "hsm-project-key-vmpbackup"
  _backup_cse_kms_multiregion_ring_name     = "cse-cmek-v1"
  _backup_cse_kms_multiregion_ring_location = try(local.spec.kms.multiregion.location, "europe")
  _backup_cse_kms_multiregion_key_link      = "projects/${local.project.id}/locations/${local._backup_cse_kms_multiregion_ring_location}/keyRings/${local._backup_cse_kms_multiregion_ring_name}/cryptoKeys/${local._backup_cse_kms_multiregion_key_name}"

  _backup_cse_keys = [
    local._backup_cse_kms_key_link,
    local._backup_cse_kms_backup_key_link,
    local._backup_cse_kms_multiregion_key_link,
  ]

  _backup_cse_kms = {
    keys = local._backup_keys
    key = {
      name     = local._backup_cse_kms_key_name
      ring     = local._backup_cse_kms_ring_name
      location = local._backup_cse_kms_ring_location
      link     = local._backup_cse_kms_key_link

      backup = {
        name     = local._backup_cse_kms_backup_key_name
        ring     = local._backup_cse_kms_backup_ring_name
        location = local._backup_cse_kms_backup_ring_location
        link     = local._backup_cse_kms_backup_key_link
      }

      multiregion = {
        name     = local._backup_cse_kms_multiregion_key_name
        ring     = local._backup_cse_kms_multiregion_ring_name
        location = local._backup_cse_kms_multiregion_ring_location
        link     = local._backup_cse_kms_multiregion_key_link
      }
    }
  }
}

output "kms" {
  value = local._use_vmp_kms ? local._vmp_kms : local._cse_kms
}

output "kms_cse" {
  value = local._cse_kms
}

output "backup_kms_cse" {
  value = local._backup_cse_kms
}

output "kms_vmp" {
  value = local._vmp_kms
}
