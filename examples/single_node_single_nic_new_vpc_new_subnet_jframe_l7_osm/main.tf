locals {
  custom_tags = {
    Owner         = var.owner
    f5xc-tenant   = var.f5xc_tenant
    f5xc-template = "f5xc_gcp_cloud_ce_single_node_single_nic_new_vpc_new_subnet_jframe_l7_osm"
  }
}

module "f5xc_gcp_cloud_ce_single_node_single_nic_new_vpc_new_subnet_jframe_l7_osm" {
  source                                 = "../../modules/f5xc/ce/gcp"
  owner                                  = var.owner
  is_sensitive                           = false
  has_public_ip                          = true
  ssh_public_key                         = file(var.ssh_public_key_file)
  status_check_type                      = "cert"
  gcp_region                             = var.gcp_region
  gcp_project_id                         = var.gcp_project_id
  gcp_instance_type                      = var.gcp_instance_type
  gcp_instance_image                     = var.gcp_instance_image
  gcp_instance_disk_size                 = var.gcp_instance_disk_size
  f5xc_tenant                            = var.f5xc_tenant
  f5xc_api_url                           = var.f5xc_api_url
  f5xc_namespace                         = var.f5xc_namespace
  f5xc_api_token                         = var.f5xc_api_token
  f5xc_token_name                        = format("%s-%s-%s", var.project_prefix, var.f5xc_cluster_name, var.project_suffix)
  f5xc_cluster_name                      = format("%s-%s-%s", var.project_prefix, var.f5xc_cluster_name, var.project_suffix)
  f5xc_api_p12_file                      = var.f5xc_api_p12_file
  f5xc_ce_slo_subnet                     = var.f5xc_ce_slo_subnet
  f5xc_ce_gateway_type                   = var.f5xc_ce_gateway_type
  f5xc_sms_provider_name                 = "gcp"
  f5xc_api_p12_cert_password             = var.f5xc_api_p12_cert_password
  f5xc_secure_mesh_site_version          = var.f5xc_secure_mesh_site_version
  f5xc_ce_performance_enhancement_mode   = var.f5xc_ce_performance_enhancement_mode
  f5xc_enable_offline_survivability_mode = var.f5xc_enable_offline_survivability_mode
  f5xc_ce_nodes = {
    node0 = {
      az = format("%s-%s", var.gcp_region, var.gcp_zone)
    }
  }
  providers = {
    google   = google.default
    restful  = restful.default
    volterra = volterra.default
  }
}

output "f5xc_gcp_cloud_ce_single_node_single_nic_new_vpc_new_subnet_jframe_l7_osm" {
  value = module.f5xc_gcp_cloud_ce_single_node_single_nic_new_vpc_new_subnet_jframe_l7_osm
}