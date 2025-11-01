locals {
  ipam = {
    secret_names = {
      username = "ipam-username",
      password = "ipam-password"
    }
  }
  server = {
    wsus = {
      url = local._platform_env == "dev" ? "http:xxxxxxxxxx30" : "hxxxxxxxxxxxxx530"
    }
  }
  directorys = {
    windows = {
      vmp = "C:\\VMP"
    }
  }
  files = {
    base_software = {
      to_install = "software_to_install.json"
    }
  }
}

output "ipam" {
  value = local.ipam
}

output "directorys" {
  value = local.directorys
}

output "files" {
  value = local.files
}

output "server" {
  value = local.server
}
