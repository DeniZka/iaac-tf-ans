tf=./terraform

#read environment variables there
include ./script/.env
#export environment variables for bash scripts
export $(shell sed 's/=.*//' ./script/.env)

#test env reading
print:
	./test.sh
	echo $(TEST)

all: configure apply

configure: configure-env configure-tf 

configure-env:
	touch ./scritp/.env
	./script/env.py

configure-tf:
	./script/tf-pve-plug.sh
	terraform -chdir=$(tf) init

apply:
	terraform -chdir=$(tf) apply

clean:
	rm -rf $(tf)/*.log
	rm -rf $(tf)/.terraform
	rm -rf $(tf)/terraform.tfstate
	rm -rf $(tf)/*.backup
	rm -rf $(tf)/.terraform.lock.hcl
