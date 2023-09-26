.PHONY: infrastructure tear-down

infrastructure:
	terraform init
	terraform apply -auto-approve

tear-down:
	terraform destroy -auto-approve
	rm -rf .terraform
	rm -rf terraform.tfstate.d
