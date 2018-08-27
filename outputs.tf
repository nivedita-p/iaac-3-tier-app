output "web_lb_ip" {
  value = "${google_compute_forwarding_rule.web_lb.ip_address}"
}

output "app_lb_ip" {
  value = "${google_compute_forwarding_rule.app_lb.ip_address}"
}

output "db_instance_name" {
  value = "${google_sql_database_instance.db_instance01.name}"
}

output "db_instance_ip" {
  value = "${google_sql_database_instance.db_instance01.ip_address}"
}
