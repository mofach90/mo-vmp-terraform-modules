locals {
  spec = try(var.workload.spec, {})
}
