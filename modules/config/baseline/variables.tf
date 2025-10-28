variable "project_id" {
  type        = string
  description = "Google Cloud Project ID"
}

variable "region" {
  type        = string
  description = "Primary region for this platform environment"
}

variable "environment" {
  type        = string
  description = "Name of the environment"
}

variable "vmp_config_branch" {
  type        = string
  default     = "main"
  description = "Alternate branch to use. Can be useful during hotfixing and development. Use via env vars."
}
