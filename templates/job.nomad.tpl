# ========================================================================
# NOMAD JOB - ${NAME}
# ========================================================================

job "${NAME}" {
  datacenters = local.datacenters
  namespace = local.namespace

  update {
    max_parallel = 1
  }

  reschedule {
    attempts = 3
    interval = "1h"
    delay = "15m"
    delay_function = "constant"
    unlimited = false
  }

%{~ if GROUP.enabled }
# ------------------------------------------------------------------------
# NOMAD GROUP START - ${GROUP.name}
# ------------------------------------------------------------------------
  group "${GROUP.name}" {
    count = local.count

    restart {
      attempts = 3
      delay = "1m"
      mode = "fail"
    }
    
    network {
      mode = "bridge"
      port "http" {
        to = 80
      }
    }

%{~ if GROUP.services_enabled }
# ------------------------------------------------------------------------
# SERVICE REGISTRATIONS (CONSUL)
# ------------------------------------------------------------------------
%{~ for svc in GROUP.services }
    ${indent(4,base64decode(svc))}
%{~ endfor }
%{~ endif }
# ------------------------------------------------------------------------
# NOMAD TASKS
# ------------------------------------------------------------------------
%{~ for task in GROUP.tasks }
    ${indent(4,base64decode(task))}
%{~ endfor }
  }
# ------------------------------------------------------------------------
# NOMAD GROUP END - ${GROUP.name}
# ------------------------------------------------------------------------
%{~ endif }
}

# ========================================================================
# NOMAD JOB - CUSTOMIZATION
# ========================================================================

# Values are read from "var.group_settings"
locals {
  datacenters = ${jsonencode(lookup(GROUP.settings,"datacenters",["dc1"]))}
  namespace = "${lookup(GROUP.settings,"namespace","default")}"
  count = "${lookup(GROUP.settings,"count",1)}"
}
