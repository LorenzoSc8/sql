module "project" {
  source          = "./modules/project"
  name            = "my-db-project"
  services = [
    "servicenetworking.googleapis.com"
  ]
}

module "vpc" {
  source     = "./modules/net-vpc"
  project_id = module.project.project_id
  name       = "my-network"
  psa_ranges = {cloudsql-ew1-0="10.60.0.0/16"}
}

module "db" {
  source           = "./modules/cloudsql-instance"
  project_id       = module.project.project_id
  network          = module.vpc.self_link
  name             = "db"
  region           = "europe-west1"
  database_version = "POSTGRES_13"
  tier             = "db-g1-small"
}