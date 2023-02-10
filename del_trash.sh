# /bin/bash
# Улалитьлишнее и ДКСТРОЙ!!!!


terraform destroy -auto-approve
rm -R .terraform*
rm terraform.tfstate*
rm join_*
terraform init
#terraform apply -auto-approve
