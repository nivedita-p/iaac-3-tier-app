resource "google_compute_firewall" "web_firewall" {
  name    = "web-firewall"
  project   = "${var.project}"
  network = "default"
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  target_tags = ["web"]
}

resource "google_compute_firewall" "app_firewall" {
  name    = "app-firewall"
  project   = "${var.project}"
  network = "default"
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
  source_tags = ["web"]
  # need to add source_ranges as source_tags are not working for some reason
  source_ranges = [
    "${google_compute_instance.web01.network_interface.0.access_config.0.assigned_nat_ip}/32",
    "${google_compute_instance.web02.network_interface.0.access_config.0.assigned_nat_ip}/32"
  ]
  target_tags = ["app"]
}
