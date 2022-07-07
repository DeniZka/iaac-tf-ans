#!/usr/bin/python3
from __future__ import print_function

import sys
import os
import yaml
from yaml.loader import SafeLoader
#print into stderr not in stdout
def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

#read env variables
playbook_dir = os.environ['ANSIBLE_PLAYBOOK_DIR']
last_ch = os.environ['SCRIPT_SSH_LAST_CHOSEN']
hosts = os.environ['ANSIBLE_INVENTORY']

lst = []

#read hosts
print(hosts)
with open(hosts, 'r') as f:
  d = yaml.load(f, Loader=SafeLoader)

#combine answers
idx = 0
eprint(d['nodes']['hosts'])
for h in d['nodes']['hosts'] :
  ip = d['nodes']['hosts'][h]['ansible_host']
  lst.append([h, ip])

#  
eprint("chose availavle host")
for i in range(0, len(lst)):
  print('[' + str(i)+ ']: ', lst[i][0], "\t", lst[i][1])
sel = input('Return for last selected [' + last_ch + '] : ')

if not sel:
  sel = last_ch

if int(sel) > len(lst) - 1:
  print("stupido")
else:
  if sel != last_ch: #replace lasts selected environment statement
    os.system('sed -ri \'s/SCRIPT_SSH_LAST_CHOSEN=[[:digit:]]+/SCRIPT_SSH_LAST_CHOSEN=' + str(sel) + '/\' script/.env')
  os.system('ssh -J root@bms-devops.ru -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@' + lst[int(sel)][1])

#TODO: save environment value

