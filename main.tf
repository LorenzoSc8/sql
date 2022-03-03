
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
    subnets = [
    {
      ip_cidr_range = "10.0.16.0/24"
      name          = "production"
      region        = "europe-west2"
      secondary_ip_range = {}
    }
  ]
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

module "simple-vm-example" {
  source     = "./modules/compute-vm"
  project_id = module.project.project_id
  zone     = "europe-west1-b"
  name       = "test"
  network_interfaces = [{
    network    = module.vpc.self_link
    subnetwork = module.vpc.subnet_self_links["europe-west2/production"]
    nat        = false
    addresses  = null
  }]
  service_account_create = true
}
