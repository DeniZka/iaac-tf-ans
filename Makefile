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

# If the first argument is "run"...
ifeq (play,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "run"
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(RUN_ARGS):;@:)
endif



env:
	env
#test env reading
print:
#	./test.sh
	echo $(ANSIBLE_HOST_KEY_CHECKING)
	
all: configure apply

nginx-distro:
	ansible-playbook ansible/pve-nginx-distro.yml

configure: configure-ssh-jump configure-id-rsa-pub configure-env configure-tf configure-mysql

configure-ssh-jump:
	echo "Ansible jump access for bms-devops.ru pve"
	ssh-copy-id root@bms-devops.ru

configure-env:
#	touch ./scritp/.env
	./script/env.py

configure-tf:
	./script/tf-pve-plug.sh
	terraform -chdir=$(tf) init

configure-id-rsa-pub:
	./script/add-id-rsa.sh

configure-mysql:
	./script/mysql-get-last-repo.sh
	
init:
	terraform -chdir=$(tf) init

apply: 
    #nginx-distro
	terraform -chdir=$(tf) apply

play:
	ansible-playbook $(ANSIBLE_PLAYBOOK_DIR)/$(RUN_ARGS)

destroy:
	terraform -chdir=$(tf) destroy

clean:
	rm -rf $(tf)/*.log
	rm -rf $(tf)/.terraform
	rm -rf $(tf)/terraform.tfstate
	rm -rf $(tf)/*.backup
	rm -rf $(tf)/.terraform.lock.hcl
