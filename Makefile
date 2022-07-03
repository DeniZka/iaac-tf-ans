tf=./terraform
SHELL:=/usr/bin/bash
#read environment variables there
$(shell touch ./script/.env)
include ./script/.env
#export environment variables for bash scripts
export $(shell sed 's/=.*//' ./script/.env)
#ifneq (,$(wildcard ./script/.env)
#	include ./script/.env
#	export
#endif
test:
	env
#test env reading
print:
#	./test.sh
	/usr/bin/bash /usr/bin/echo $ANSIBLE_INVENTORY
	
all: configure apply

configure: configure-id-rsa-pub configure-env configure-tf 

configure-env:
#	touch ./scritp/.env
	./script/env.py

configure-tf:
	./script/tf-pve-plug.sh
	terraform -chdir=$(tf) init

configure-id-rsa-pub:
	./script/add-id-rsa.sh

apply:
	terraform -chdir=$(tf) apply

destroy:
	terraform -chdir=$(tf) destroy

clean:
	rm -rf $(tf)/*.log
	rm -rf $(tf)/.terraform
	rm -rf $(tf)/terraform.tfstate
	rm -rf $(tf)/*.backup
	rm -rf $(tf)/.terraform.lock.hcl
