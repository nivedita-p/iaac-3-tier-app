resource "google_compute_instance" "web01" {
  project = "${var.project}"
  zone = "${var.zone}"
  name = "web01"
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
  tags = ["web"]
  metadata_startup_script = "apt update && apt install nginx -y"
  # Or you can reference a bootstrap script from a bucket to use puppet/ansible
}

resource "google_compute_instance" "web02" {
  project = "${var.project}"
  zone = "${var.zone}"
  name = "web02"
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
  tags = ["web"]
  metadata_startup_script = "apt update && apt install nginx -y"
  # Or you can reference a bootstrap script from a bucket to use puppet/ansible
}

resource "google_compute_http_health_check" "web_health_check" {
  name = "web-health-check"
  project   = "${var.project}"
  request_path = "/"
  check_interval_sec = 1
  timeout_sec = 1
}

resource "google_compute_target_pool" "web_pool" {
  name = "web-pool"
  region = "${var.region}"
  project   = "${var.project}"
  instances = [
    "${google_compute_instance.web01.self_link}",
    "${google_compute_instance.web02.self_link}",
  ]

  health_checks = [
    "${google_compute_http_health_check.web_health_check.name}",
  ]
}

resource "google_compute_forwarding_rule" "web_lb" {
  name = "web-lb"
  project   = "${var.project}"
  region = "${var.region}"
  target = "${google_compute_target_pool.web_pool.self_link}"
  port_range = "80"
}
