service {
  name = "${NAME}"
  port = "http"
  connect {
    sidecar_task {
      resources {
        cpu = ${CPU}
        memory = ${RAM}
      }
    }
    sidecar_service {}
  }
}
