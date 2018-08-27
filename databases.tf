resource "google_sql_database_instance" "db_instance01" {
  region           = "${var.region}"
  project          = "${var.project}"
  database_version = "MYSQL_5_6"
  settings {
    tier = "D0"
    ip_configuration {
      ipv4_enabled = true
      authorized_networks = [
        {
          value = "${google_compute_instance.app01.network_interface.0.access_config.0.assigned_nat_ip}/32"
        },
        {
          value = "${google_compute_instance.app02.network_interface.0.access_config.0.assigned_nat_ip}/32"
        },
      ]
    }
  }
}

resource "google_sql_database" "interview_db" {
  name      = "interview-db"
  project   = "${var.project}"
  instance  = "${google_sql_database_instance.db_instance01.name}"
  charset   = "latin1"
  collation = "latin1_swedish_ci"
}

resource "google_sql_user" "interview_user_app01" {
  name     = "${var.mysql_user}"
  project  = "${var.project}"
  instance = "${google_sql_database_instance.db_instance01.name}"
  host     = "${google_compute_instance.app01.network_interface.0.access_config.0.assigned_nat_ip}"
  password = "${var.mysql_pass}"
}

resource "google_sql_user" "interview_user_app02" {
  name     = "${var.mysql_user}"
  project   = "${var.project}"
  instance = "${google_sql_database_instance.db_instance01.name}"
  host     = "${google_compute_instance.app02.network_interface.0.access_config.0.assigned_nat_ip}"
  password = "${var.mysql_pass}"
}
