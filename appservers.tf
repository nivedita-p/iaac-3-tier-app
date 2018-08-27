resource "google_compute_instance" "app01" {
  project = "${var.project}"
  zone = "${var.zone}"
  name = "app01"
  machine_type = "f1-micro"
  boot_disk {
    initialize_params {
      image = "ubuntu-1604-xenial-v20180814"
    }
  }
  network_interface {
    network = "default"
    access_config {
    }
  }
  tags = ["app"]
  metadata_startup_script = "apt update && apt install tomcat8 -y"
  # Or you can reference a bootstrap script from a bucket to use puppet/ansible
}

resource "google_compute_instance" "app02" {
  project = "${var.project}"
  zone = "${var.zone}"
  name = "app02"
  machine_type = "f1-micro"
  boot_disk {
    initialize_params {
      image = "ubuntu-1604-xenial-v20180814"
    }
  }
  network_interface {
    network = "default"
    access_config {
    }
  }
  tags = ["app"]
  metadata_startup_script = "apt update && apt install tomcat8 -y"
  # Or you can reference a bootstrap script from a bucket to use puppet/ansible
}

resource "google_compute_http_health_check" "app_health_check" {
  name = "app-health-check"
  project   = "${var.project}"
  request_path = "/"
  check_interval_sec = 1
  timeout_sec = 1
  port = 8080
}

resource "google_compute_target_pool" "app_pool" {
  name = "app-pool"
  region = "${var.region}"
  project   = "${var.project}"
  instances = [
    "${google_compute_instance.app01.self_link}",
    "${google_compute_instance.app02.self_link}",
  ]

  health_checks = [
    "${google_compute_http_health_check.app_health_check.name}",
  ]
}

# Internal load balancer uses backend_service and that required managed instance group
# There was not enough time to setup that module, hence using external LB
resource "google_compute_forwarding_rule" "app_lb" {
  name = "app-lb"
  project   = "${var.project}"
  region = "${var.region}"
  target = "${google_compute_target_pool.app_pool.self_link}"
  load_balancing_scheme = "EXTERNAL"
  port_range = "8080"
}
