variable "workload" {
  type        = any
  description = "workload yaml from repo vmp-workloads"
}

variable "vmp_config_branch" {
  type        = string
  default     = "main"
  description = "Alternate branch to use. Can be useful during hotfixing and development. Use via env vars."
}
