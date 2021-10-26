task "${NAME}" {
  driver = "docker"

  config {
    image = "${IMAGE}"
    ports = ["http"]
  }

  resources {
    cpu = ${CPU}
    memory = ${RAM}
    memory_max = ${RAM_MAX}
  }
}
