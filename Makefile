_invoke_cluster_d = cd ./cluster
_invoke_deploy_d = cd ./deploy

.ONESHELL:

default:
	@echo "Creates a Terraform system from a template."
	@echo "The following commands are available:\n"
	@echo " - apply_cluster      : Creates AWS infrastructure (EKS, VPC, etc)"
	@echo " - apply_deploy       : Deploys to IKS cluster"
	@echo " - destroy            : Deletes the entire infrastructure"

apply_cluster:
	$(call check_defined, ENV, Please set the ENV to plan for. Values should be dev, test, mgmt or prod)

	@${_invoke_cluster_d}

	@terraform init
	@terraform fmt

	@echo "Pulling the required modules..."
	@terraform get

	@echo "Switching to the [$(value ENV)] environment ..."
	@terraform workspace select $(value ENV) || terraform workspace new $(value ENV)

	terraform plan \
  	  -var-file=../envs/$(value ENV).tfvars \
		-out=./$(value ENV)-cluster.plan

	terraform apply \
		./$(value ENV)-cluster.plan

	@rm ./$(value ENV)-cluster.plan

apply_deploy:
	$(call check_defined, ENV, Please set the ENV to plan for. Values should be dev, test, mgmt or prod)

	@$(_invoke_deploy_d)

	@terraform init
	@terraform fmt

	@echo "Pulling the required modules..."
	@terraform get

	@echo "Switching to the [$(value ENV)] environment ..."
	@terraform workspace select $(value ENV) || terraform workspace new $(value ENV)

	terraform plan \
		-var-file=../envs/$(value ENV).tfvars \
		-out=./$(value ENV)-deploy.plan

	terraform apply \
		./$(value ENV)-deploy.plan

	@rm ./$(value ENV)-cluster.plan

destroy:
	@echo "Destroying cluster ..."
	@${_invoke_cluster_d}

	@echo "Switching to the [$(value ENV)] environment ..."
	@terraform workspace select $(value ENV)

	@terraform destroy \
		-auto-approve \
		-var-file=../envs/$(value ENV).tfvars

	@cd ..

	@echo "Destroying services ..."
	@${_invoke_deploy_d}

	@terraform destroy \
		-auto-approve \
		-var-file=../envs/$(value ENV).tfvars


# Check that given variables are set and all have non-empty values,
# die with an error otherwise.
#
# Params:
#   1. Variable name(s) to test.
#   2. (optional) Error message to print.
check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $2, ($2))))
