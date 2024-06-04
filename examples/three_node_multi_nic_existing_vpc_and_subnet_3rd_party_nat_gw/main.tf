locals {
  custom_tags = {
    Owner         = var.owner
    f5xc-tenant   = var.f5xc_tenant
    f5xc-template = "f5xc_gcp_cloud_ce_three_node_multi_nic_existing_vpc_and_subnet_3rd_party_nat_gw"
  }
}

module "vpc_slo" {
  source       = "terraform-google-modules/network/google"
  mtu          = 1460
  version      = "~> 6.0"
  project_id   = var.gcp_project_id
  network_name = "${var.project_prefix}-${var.project_name}-vpc-slo-${var.gcp_region}-${var.project_suffix}"
  subnets = [
    {
      subnet_name   = "${var.project_prefix}-${var.project_name}-slo-${var.gcp_region}-${var.project_suffix}"
      subnet_ip     = "192.168.1.0/24"
      subnet_region = var.gcp_region
    }
  ]
}

module "vpc_sli" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 6.0"
  project_id   = var.gcp_project_id
  network_name = "${var.project_prefix}-${var.project_name}-vpc-sli-${var.gcp_region}-${var.project_suffix}"
  mtu          = 1460
  subnets = [
    {
      subnet_name   = "${var.project_prefix}-${var.project_name}-sli-${var.gcp_region}-${var.project_suffix}"
      subnet_ip     = "192.168.2.0/24"
      subnet_region = var.gcp_region
    }
  ]
  delete_default_internet_gateway_routes = true
}

resource "google_compute_address" "nat" {
  count   = 1
  name    = "${module.vpc_slo.network_name}-${var.gcp_region}-nat-${count.index}"
  project = var.gcp_project_id
  region  = var.gcp_region
}

module "nat" {
  source        = "terraform-google-modules/cloud-nat/google"
  version       = "~> 2.0"
  project_id    = var.gcp_project_id
  region        = var.gcp_region
  router        = "${var.project_prefix}-${var.project_name}-nat-router-${var.gcp_region}-${var.project_suffix}"
  create_router = true
  name          = "${var.project_prefix}-${var.project_name}-nat-config-${var.gcp_region}-${var.project_suffix}"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  # nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips       = google_compute_address.nat.*.self_link
  network       = module.vpc_slo.network_name
}

module "f5xc_gcp_cloud_ce_three_node_multi_nic_existing_vpc_and_subnet_3rd_party_nat_gw" {
  depends_on                      = [module.vpc_slo, module.vpc_sli, module.nat]
  source                          = "../../modules/f5xc/ce/gcp"
  owner                           = var.owner
  is_sensitive                    = false
  has_public_ip                   = false
  ssh_public_key = file(var.ssh_public_key_file)
  status_check_type               = "cert"
  gcp_region                      = var.gcp_region
  gcp_project_id                  = var.gcp_project_id
  gcp_instance_type               = var.gcp_instance_type
  gcp_instance_image              = var.gcp_instance_image
  gcp_instance_disk_size          = var.gcp_instance_disk_size
  gcp_existing_network_slo        = var.gcp_existing_network_slo
  gcp_existing_network_sli        = var.gcp_existing_network_sli
  gcp_existing_subnet_network_slo = var.gcp_existing_subnet_network_slo
  gcp_existing_subnet_network_sli = var.gcp_existing_subnet_network_sli
  f5xc_tenant                     = var.f5xc_tenant
  f5xc_api_url                    = var.f5xc_api_url
  f5xc_namespace                  = var.f5xc_namespace
  f5xc_api_token                  = var.f5xc_api_token
  f5xc_token_name = format("%s-%s-%s", var.project_prefix, var.f5xc_cluster_name, var.project_suffix)
  f5xc_cluster_name = format("%s-%s-%s", var.project_prefix, var.f5xc_cluster_name, var.project_suffix)
  f5xc_api_p12_file               = var.f5xc_api_p12_file
  f5xc_ce_gateway_type            = var.f5xc_ce_gateway_type
  f5xc_api_p12_cert_password      = var.f5xc_api_p12_cert_password
  f5xc_ce_nodes = {
    node0 = {
      az = format("%s-%s", var.gcp_region, var.gcp_zone_node0)
    }
    node1 = {
      az = format("%s-%s", var.gcp_region, var.gcp_zone_node1)
    }
    node2 = {
      az = format("%s-%s", var.gcp_region, var.gcp_zone_node2)
    }
  }
  providers = {
    google   = google.default
    volterra = volterra.default
  }
}

output "f5xc_gcp_cloud_ce_three_node_multi_nic_existing_vpc_and_subnet_3rd_party_nat_gw" {
  value = module.f5xc_gcp_cloud_ce_three_node_multi_nic_existing_vpc_and_subnet_3rd_party_nat_gw
}

