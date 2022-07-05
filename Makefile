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
  HOST_NAME := $(word 2,$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(HOST_NAME):;@:)
endif

#parse args if ans-check presents
ifeq (ans-check,$(findstring ans-check,$(firstword $(MAKECMDGOALS))))
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  HOST_NAME := $(word 2,$(MAKECMDGOALS))
  $(eval $(HOST_NAME):;@:)
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
	ansible-playbook $(ANSIBLE_PLAYBOOK_DIR)/$(HOST_NAME)

#warning ans-check is keyword for args parsing	
ans-check:
	./script/ans-check.py $(RUN_ARGS)
	#echo $(HOST_NAME)	
	
#warning ans-check is keyword for args parsing		
ans-check-and-play: ans-check play

destroy:
	terraform -chdir=$(tf) destroy

clean:
	rm -rf $(tf)/*.log
	rm -rf $(tf)/.terraform
	rm -rf $(tf)/terraform.tfstate
	rm -rf $(tf)/*.backup
	rm -rf $(tf)/.terraform.lock.hcl
