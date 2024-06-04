provider "volterra" {
  api_p12_file = var.f5xc_api_p12_file
  url          = var.f5xc_api_url
  alias        = "default"
}

provider "google" {
  credentials = var.gcp_application_credentials != "" ? file(var.gcp_application_credentials) : null
  project     = var.gcp_project_id
  region      = var.gcp_region
  alias       = "default"
}