locals {
  events = {
    topic = "${local._platform_project_name}-monitoring"
  }
}

output "events" {
  value = local.events
}
