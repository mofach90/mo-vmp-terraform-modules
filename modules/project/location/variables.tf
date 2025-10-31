variable "regions_eu_special" {
  type = map(list(string))
  default = {
    "europe-west1" : [ # Belgium
      "europe-west1-b",
      "europe-west1-c",
      "europe-west1-d",
    ],
  }
}

variable "regions_eu_abc" {
  type = list(string)
  default = [
    "europe-central2",   # Poland
    "europe-north1",     # Finland
    "europe-southwest1", # Spain
    "europe-west3",      # Germany
    "europe-west4",      # Netherlands
    "europe-west8",      # Italy
    "europe-west9",      # France
    "europe-west10",     # Germany
    "europe-west12",     # Italy
  ]
}

variable "region" {
  type    = string
  default = "europe-west3"
  validation {
    condition     = try(regex("europe-west[13]", var.region), null) != null
    error_message = "The provided region is not supported"
  }
}

variable "zone" {
  type    = string
  default = null
}
