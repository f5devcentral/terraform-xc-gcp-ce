locals {
  custom_tags = {
    Owner         = var.owner
    f5xc-tenant   = var.f5xc_tenant
    f5xc-template = "f5xc_gcp_cloud_ce_three_node_single_nic_existing_vpc_and_subnet_3rd_party_nat_gw"
  }
}

module "f5xc_gcp_cloud_ce_three_node_single_nic_existing_vpc_and_subnet_3rd_party_nat_gw" {
  source                          = "../../modules/f5xc/ce/gcp"
  owner                           = var.owner
  is_sensitive                    = false
  has_public_ip                   = false
  ssh_public_key                  = file(var.ssh_public_key_file)
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
  f5xc_token_name                 = format("%s-%s-%s", var.project_prefix, var.f5xc_cluster_name, var.project_suffix)
  f5xc_cluster_name               = format("%s-%s-%s", var.project_prefix, var.f5xc_cluster_name, var.project_suffix)
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

output "f5xc_gcp_cloud_ce_three_node_single_nic_existing_vpc_and_subnet_3rd_party_nat_gw" {
  value = module.f5xc_gcp_cloud_ce_three_node_single_nic_existing_vpc_and_subnet_3rd_party_nat_gw
}

