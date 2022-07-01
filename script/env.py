#!/usr/bin/python
import os
import dotenv

print('Setting UP .env file')

fenv = dotenv.find_dotenv()
print(fenv)
dotenv.load_dotenv(fenv)

tid = os.environ.get('PM_API_TOKEN_ID')
tse = os.environ.get('PM_API_TOKEN_SECRET')



print ('Enter proxmox API token ID (blah-blah@pve!blah-blah)')
if tid :
    print('Now: ', tid) #FIXME REMOVE
    #print ('Now: ', tid[0:3], '..', tid[-3:]) #kond of secure
else:
    print ('token ID is empty')

s = input('Press [Return] to skip: ')
if s :
    dotenv.set_key(fenv, "PM_API_TOKEN_ID", s)
else:
    print('skipped')


print ('Enter proxmox API token secret (too-hard-to-hack-hash-code)')
if tse:
    print ('Now: ', tse)
else:
    print ('token Secret is empty')
s = input('Press [Return] to skip: ')
if s :
    dotenv.set_key(fenv, "PM_API_TOKEN_SECRET", s)
else:
    print('skipped')

#ansible configurations
cwd = os.getcwd()
print('Setting up Ansible inventory file')
dotenv.set_key(fenv, "ANSIBLE_INVENTORY", cwd + '/ansible/inventory/hosts')
print('Disable Ansible host key checking')
dotenv.set_key(fenv, "ANSIBLE_HOST_KEY_CHECKING", "False")

print('.env configuration done!')

