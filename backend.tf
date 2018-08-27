terraform {
backend "gcs" {
  bucket  = "npaul-tf-state"
  path    = "/terraform.tfstate"
  project = "npaul-203410"
}
}
