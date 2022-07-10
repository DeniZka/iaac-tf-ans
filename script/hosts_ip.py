#!/usr/bin/python3
import sys
import os
import yaml
from yaml.loader import SafeLoader

def interact_host(lst, last_ch):
  return input('Return for last selected [' + last_ch + ']: ')

id_or_host_or_ip = ''
if len(sys.argv) > 1:
  id_or_host_or_ip = sys.argv[1]

#read env variables
playbook_dir = os.environ['ANSIBLE_PLAYBOOK_DIR']
last_ch = os.environ['SCRIPT_SSH_LAST_CHOSEN']
hosts = os.environ['ANSIBLE_INVENTORY']

#read hosts
with open(hosts, 'r') as f:
  d = yaml.load(f, Loader=SafeLoader)

#combine answers
lst = []
for h in d['nodes']['hosts'] :
  ip = d['nodes']['hosts'][h]['ansible_host']
  lst.append([h, ip])
  
#print(lst)
print("Choose enslaved host:")
for i in range(0, len(lst)):
  print('[' + str(i)+ ']: ', lst[i][0], "\t", lst[i][1])

sel = None
if id_or_host_or_ip:
  if id_or_host_or_ip.isdigit():
    id_or_ip = int(id_or_host_or_ip)
    if id_or_ip < 100: #id
      if id_or_ip < len(lst):
        sel = id_or_ip
      else:  
        print("No, there is no index like", id_or_ip)
        exit()
    else: #ip
      for i in range(len(lst)):
      	if lst[i][1] == '172.16.0.' + id_or_host_or_ip:
      	  sel = i
      	  break
      if sel == None:
        print('There is no', id_or_ip, 'IP in hosts.yml')
        exit()
  else: #string
    for i in range(len(lst)):
      if lst[i][0] == id_or_host_or_ip:
        sel = i
        break
    if sel == None:
      print('There is not host', id_or_host_or_ip, 'in hosts.yml')
      exit()
else: #no argument strait check 
  sel = interact_host(lst, last_ch)
  if not sel:
    sel = last_ch


if int(sel) > len(lst) - 1:
  print("stupido")
else:

  if sel != last_ch: #replace lasts selected environment statement
    os.system('sed -ri \'s/SCRIPT_SSH_LAST_CHOSEN=[[:digit:]]+/SCRIPT_SSH_LAST_CHOSEN=' + str(sel) + '/\' script/.env')
  os.system('ssh -J root@bms-devops.ru -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@' + lst[int(sel)][1])

