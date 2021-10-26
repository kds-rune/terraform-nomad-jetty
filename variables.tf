variable "job_name" {
  description = "The name of the Nomad job"
  type = string
  default = "example-whoami"
}

# -----------------------------------------------
# NOMAD JOB VARIABLES
# -----------------------------------------------

variable "group_settings" {
  description = ""
  type = object({})
  default = {}
}

variable "whoami_settings" {
  description = ""
  type = object({})
  default = {}
}

variable "fluentbit_settings" {
  description = ""
  type = object({})
  default = {}
}

# -----------------------------------------------
# OTHER VARIABLES
# -----------------------------------------------

variable "render_jobfile" {
  type = bool
  default = false
}
