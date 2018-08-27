variable "project" {
  type    = "string"
  default = "npaul-203410"
}

variable "tf-state-bucket" {
  type = "string"
  default = "npaul-tf-state"
}

variable "region" {
  type    = "string"
  default = "europe-west1"
}

variable "zone" {
  type    = "string"
  default = "europe-west1-b"
}

variable "db_name" {
  type = "string"
  default = "interview-db"
}

variable "mysql_user" {
  type = "string"
  default = "interview"
}

variable "mysql_pass" {
  type = "string"
  default = "CHANGE_ME"
}
