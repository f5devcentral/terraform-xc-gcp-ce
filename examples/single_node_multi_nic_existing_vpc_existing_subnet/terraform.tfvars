owner                    = "owner_email_address"
project_prefix           = "f5xc"
project_suffix           = "11"
#ssh_public_key_file = "path to ssh public key file"
gcp_zone                 = "b"
gcp_region               = "us-east1"
gcp_instance_image       = "rhel9-20240216075746-multi-voltmesh-us"
gcp_existing_network_slo = ""
gcp_existing_network_sli = ""

#f5xc_tenant         = "full f5 xc tenant name e.g. playground-abcdefg"
#f5xc_api_url        = "f5 xc api url e.g. https://playground.console.ves.volterra.io/api"
f5xc_cluster_name = "gcp-ce-test"
#f5xc_api_p12_file   = "path_to_api_cert_file"
f5xc_ce_slo_subnet       = "192.168.0.0/26"
f5xc_ce_sli_subnet       = "192.168.0.64/26"