provider "volterra" {
  api_p12_file = var.f5xc_api_p12_file
  url          = var.f5xc_api_url
  alias        = "default"
}

provider "google" {
  credentials = var.gcp_application_credentials != "" ? file(var.gcp_application_credentials) : null
  project     = var.gcp_project_id
  region      = var.gcp_region
  zone        = format("%s-%s", var.gcp_region, var.gcp_zone)
  alias       = "default"
}

provider "restful" {
  alias         = "default"
  base_url      = var.f5xc_api_url
  update_method = "PUT"
  create_method = "POST"
  delete_method = "DELETE"

  client = {
    retry = {
      status_codes = [500, 502, 503, 504]
      count           = 3
      wait_in_sec     = 1
      max_wait_in_sec = 120
    }
  }

  security = {
    apikey = [
      {
        in   = "header"
        name = "Authorization"
        value = format("APIToken %s", var.f5xc_api_token)
      }
    ]
  }
}