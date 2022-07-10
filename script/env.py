#!/usr/bin/python3
import os
import re
import dotenv #this sux, drop it

print('Setting UP .env file')


#dynamic and static variables for .env
d = {
    'PM_API_TOKEN_ID': '',
    'PM_API_TOKEN_SECRET': '',
    'ANSIBLE_INVENTORY': os.getcwd() + '/ansible/inventory/hosts.yml',
    'ANSIBLE_HOST_KEY_CHECKING': 'False',
    'ANSIBLE_TIMEOUT': 40,
    'ANSIBLE_ROLES_PATH': os.getcwd() + '/ansible/roles',
    'ANSIBLE_PLAYBOOK_DIR': os.getcwd() + '/ansible',
    'IAAC_ROOT': os.getcwd(),
    'SCRIPT_SSH_LAST_CHOSEN': '0'
}


#read .env file
sl = ''
with open('./script/.env', 'r') as f:
    sl = f.readlines()
    
#print(sl)
for l in sl:

    kv = l.split("=")
    if kv[0] == 'PM_API_TOKEN_ID':
        d['PM_API_TOKEN_ID'] = kv[1].strip()
    elif kv[0] == 'PM_API_TOKEN_SECRET':
        d['PM_API_TOKEN_SECRET'] = kv[1].strip()


print ('Enter proxmox API token ID (blah-blah@pve!blah-blah)')
if d['PM_API_TOKEN_ID'] :
    print('Now: ', d['PM_API_TOKEN_ID']) #FIXME REMOVE
    #print ('Now: ', tid[0:3], '..', tid[-3:]) #kond of secure
else:
    print ('token ID is empty')

s = input('Press [Return] to skip: ')
if s :
    d['PM_API_TOKEN_ID'] = s
else:
    print('skipped')


print ('Enter proxmox API token secret (too-hard-to-hack-hash-code)')
if d['PM_API_TOKEN_SECRET']:
    print ('Now: ', d['PM_API_TOKEN_SECRET'])
else:
    print ('token Secret is empty')
s = input('Press [Return] to skip: ')
if s :
    d['PM_API_TOKEN_SECRET'] = s
else:
    print('skipped')

#write back
with open('./script/.env', 'w') as f:
    for key, value in d.items():    
        f.write("%s=%s\n" % (key, value))

print('.env configuration done!')

