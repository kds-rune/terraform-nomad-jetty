task "${NAME}" {
  driver = "docker"
  
  lifecycle {
    hook = "prestart"
    sidecar = true
  }

  resources {
    cpu = ${CPU}
    memory = ${RAM}
    memory_max = ${RAM_MAX}
  }

  config {
    image = "${IMAGE}"
    command = "/fluent-bit/bin/fluent-bit"
    args = ["-c","/local/fluent-bit.conf"]
    memory_hard_limit = ${RAM_MAX}
  }

  template {
    destination = "/local/fluent-bit.conf"
    data = <<-HEREDOC
    [SERVICE]
      Flush     5
      Daemon    off
      Log_Level debug
    [INPUT]
      Name  tail
      Tag   tail.stdout
      Path {{ env "NOMAD_ALLOC_DIR" }}/logs/*.stdout.*
      Exclude_Path **/{{env "NOMAD_TASK_NAME" }}.*,**/connect-proxy-*
      Path_Key file
      DB {{ env "NOMAD_ALLOC_DIR" }}/logs/stdout.db
    [INPUT]
      Name  tail
      Tag   tail.stderr
      Path {{ env "NOMAD_ALLOC_DIR" }}/logs/*.stderr.*
      Exclude_Path **/{{env "NOMAD_TASK_NAME" }}.*,**/connect-proxy-*
      Path_Key file
      DB {{ env "NOMAD_ALLOC_DIR" }}/logs/stderr.db
    [OUTPUT]
      Name  stdout
      Match *
    HEREDOC
  }
}
