# Example three node ce cluster with single nic and new VPC and new subnet

This example instantiates:

- Three node CE cluster
- GCP compute instance template
- GCP compute region instance group manager
- GCP compute instance
- GCP compute subnetwork for SLO
- GCP compute network for SLO
- GCP compute firewall for SLO
- SLO interface with NAT IP

# Usage

- Prepare GPC instance image
  * To be able to start a GCP VM instance, we need an instance image. This image must be saved in the Project Storage
  * Follow instructions at [F5 XC GCP Image Download](https://docs.cloud.f5.com/docs/images/node-cloud-images#gcp)  
  * Example: gcloud compute images create rhel9-20240216075746-multi-voltmesh-us --source-uri gs://ves-images/rhel9-20240216075746-multi-voltmesh.tar.gz
  * Name of the created image will later on be used as input variable for Terraform
- Authentication can be done in different ways as outlined here: [Google Provider Authentication](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#authentication)
- In this example we use gcloud command to authenticate. Run `gcloud auth application-default login`
- Export GCP_PROJECT_ID with: `export TF_VAR_gcp_project_id="gcp_project_name"`
- Export F5 XC API certificate password with: 
  * `export VES_P12_PASSWORD="p12 password"`
  * `export TF_VAR_f5xc_api_p12_cert_password="$VES_P12_PASSWORD"` 
- Edit `terraform.tfvars` file to align with your environment
- Copy F5XC API certificate file obtained in installation step into example directory
- Initialize with: `terraform init`, optionally run `terraform plan`
- Apply with: `terraform apply -auto-approve` or destroy with: `terraform destroy -auto-approve`