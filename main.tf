# ===============================================
# PROVIDER(S)
# ===============================================

terraform {
  required_providers {
    nomad = {
      source = "hashicorp/nomad"
      version = ">= 1.4"
    }
  }
}

# ===============================================
# CUSTOMIZE TEMPLATE
# ===============================================

locals {
  
  job_name = var.job_name

  group = {
    name = "main"
    enabled = true
    services_enabled = true
    settings = var.group_settings
    
    tasks = [
      base64encode(templatefile("templates/task.whoami.tpl",{
        NAME    = lookup(var.whoami_settings,"name","whoami")
        IMAGE   = lookup(var.whoami_settings,"image","traefik/whoami:latest")
        CPU     = lookup(var.whoami_settings,"cpu",100)
        RAM     = lookup(var.whoami_settings,"ram",32)
        RAM_MAX = lookup(var.whoami_settings,"ram_max",64)
      })),

      base64encode(templatefile("templates/task.fluentbit.tpl",{
        NAME    = lookup(var.fluentbit_settings,"name","fluentbit")
        IMAGE   = lookup(var.fluentbit_settings,"image","fluent/fluent-bit:latest")
        CPU     = lookup(var.fluentbit_settings,"cpu",100)
        RAM     = lookup(var.fluentbit_settings,"ram",32)
        RAM_MAX = lookup(var.fluentbit_settings,"ram_max",64)
      })),
    ]

    services = [
      base64encode(templatefile("templates/service.whoami.tpl",{
        NAME = lookup(var.whoami_settings,"service_name","whoami")
        CPU  = lookup(var.whoami_settings,"service_cpu",100)
        RAM  = lookup(var.whoami_settings,"service_ram",32)
      })),
    ]
  }
}

# ===============================================
# RESOURCE(S)
# ===============================================

resource nomad_job "JOB" {
  jobspec = templatefile("${path.module}/templates/job.nomad.tpl",{
    NAME  = local.job_name
    GROUP = local.group
  })

  hcl2 {
    enabled = true
    allow_fs = false
  }
}

resource local_file "JOBFILE" {
  count = var.render_jobfile != false ? 1 : 0
  filename = "${path.module}/rendered/job.nomad"
  content = templatefile("${path.module}/templates/job.nomad.tpl",{
    NAME  = local.job_name
    GROUP = local.group
  })
}
