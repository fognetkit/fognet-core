variable "yc_instance_type" {
  description = "Yandex Instance Type"
  type        = string
  default     = "standard-v3" //intel-ice-lake
}

variable "yc_instance_core_count" {
  description = "Yandex Instance Core Count"
  type        = number
  default     = 2
}

variable "yc_instance_core_fraction" {
  description = "Yandex Instance Core Fraction"
  type        = number
  default     = 20 //%
}

variable "yc_instance_memory" {
  description = "Yandex Instance Memory"
  type        = number
  default     = 1 //GB
}

variable "yc_instance_ssd_size" {
  description = "Yandex Instance SSD size"
  type        = number
  default     = 10 //GB
}

variable "client_subnet" {
  description = "Client Subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "yc_zone" {
  description = "Yandex Zone"
  type        = string
  default     = "ru-central1-a"
}

variable "network" {
  type = object({
    allow_ping     = bool
    allow_outgoing = bool
    ports = list(object({
      protocol    = string
      description = string
      port        = optional(number)
    }))
  })
}

variable "packages" {
  type        = list(string)
  description = "List of packages for installation"
}

variable "run_commands" {
  type        = list(string)
  description = "List of commands to run"
}

variable "mount_bucket" {
  type = object({
    enabled = bool
    path    = string
  })
}

variable "bucket_props" {
  type = object({
    bucket             = string
    server             = string
    path_request_style = bool
    access_key         = string
    secret_key         = string
  })
}

variable "deployment_source" {
  description = "Source of deployment. Used to track how infrastructure was deployed and by whom. Can be 'manual' for local runs, 'autotest' for automated testing, 'pipeline' for CI/CD, or 'pipeline-<username>' for user-specific pipeline runs"
  type        = string
  default     = "manual"

  validation {
    condition     = can(regex("^(manual|autotest|pipeline|pipeline-.+)$", var.deployment_source))
    error_message = "The deployment_source must be 'manual', 'autotest', 'pipeline', or 'pipeline-<username>'."
  }
}