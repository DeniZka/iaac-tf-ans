#!/usr/bin/python3
import os
import sys
import yaml
from yaml.loader import SafeLoader

args = sys.argv
if len(args) < 4:
 print("USAGE: ans-check.py <hostname.yml> <vmid> <role>")

#TODO: read params
host_name = args[1].split('.')[0]
ip = args[2]
role = args[3]

# read environment variables
playbook_dir= os.environ['ANSIBLE_PLAYBOOK_DIR']
roles_path = os.environ['ANSIBLE_ROLES_PATH']
env_hosts = os.path.join(playbook_dir, "inventory/hosts.yml")


data = {}
#edit inventory file
with open(env_hosts, "r") as f:
    data = yaml.load(f, Loader=SafeLoader)
    
if host_name in data['nodes']["hosts"]:
    print("Node :", host_name, "found")
    print(data['nodes']['hosts'][host_name])
    if '.' + ip in data['nodes']['hosts'][host_name]['ansible_host']:
        print("Host", host_name, "IP found")
    else:
        print("IP does not match inventory")
        for h in data['nodes']['hosts']:
            if h == host_name: #skip active
                continue
            if ip in data['nodes']['hosts'][h]['ansible_host']:
                print("ERROR!! CHOSEN IP DUPLICATED IN ", h)
                exit()
else:
    #check ip duplication move to function
    for h in data['nodes']['hosts']:
        if ip in data['nodes']['hosts'][h]['ansible_host']:
            print("ERROR!! CHOSEN IP DUPLICATED IN ", h)
            exit()

    print("Warning! Node :", host_name, "absent")        
    data['nodes']['hosts'][host_name] = { 'ansible_host': '172.16.0.' + ip }

    with open(env_hosts, 'w') as f:
        d = yaml.dump(data, f, sort_keys=False, default_flow_style=False, width=1000)            
    print("Done! I'm filled up your inventory")
        
#role generator
if os.path.exists(os.path.join(roles_path, role)):
    print('role ', role, 'found')
else:
    print('role', role, 'NOT FOUND')
    print('Creating role', role, 'sceleton')
    os.system("cd %s && ansible-galaxy init %s" % (roles_path, role))
    

#playbook generator
if os.path.exists(os.path.join(playbook_dir, host_name + '.yml')):
    print('host', host_name, 'playbook found')
else:
    print('host', host_name, 'playbook NOT FOUND')
    print('Creating dummy playbook')

    data = [
        {
            'hosts': host_name,
            'roles': [ role ]
        }
    ]
    with open(os.path.join(playbook_dir, host_name + '.yml'), "w") as f:
        d = yaml.dump(data, f, sort_keys=False, default_flow_style=False, width=1000)
    print('Dummy playbook ready')

