variable "service_name" {
  type    = string
  default = "custom-start-points"
}

variable "env" {
  type = string
}

variable "app_port" {
  type    = number
  default = 4526
}

variable "cpu_limit" {
  type    = number
  default = 256
}

variable "mem_limit" {
  type    = number
  default = 512
}

variable "mem_reservation" {
  type    = number
  default = 32
}

variable "container_restart_policy_enabled" {
  description = "Whether to enable restart policy for the container."
  type        = bool
  default     = true
}

variable "TAGGED_IMAGE" {
  type = string
}

# App variables
variable "app_env_vars" {
  type = map(any)
  default = {
    CYBER_DOJO_PROMETHEUS               = "true"
    CYBER_DOJO_CUSTOM_START_POINTS_PORT = "4526"
  }
}

variable "ecr_replication_targets" {
  type    = list(map(string))
  default = []
}

variable "ecr_replication_origin" {
  type    = string
  default = ""
}
