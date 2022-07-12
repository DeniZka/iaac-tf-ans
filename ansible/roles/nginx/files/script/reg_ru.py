#!/usr/bin/python3

#README: https://www.reg.ru/reseller/api2doc
import os, sys
import json
import requests
username = 'grafforever@yandex.ru'
password = 'bms-devops'
domain = 'bms-devops.ru'
#NOTE: update_records is only resellers function

#subnames = ['www', 'gitlab', 'grafana', 'alertmanager', 'hello', 'prometheus']
subnames = sys.argv[1].split(':')

#check dns
d = {
  'username': username,
  'password': password,
  'domains': [
    {"dname": domain},
  ],
  "output_type": "plain"
}
jd = json.dumps(d,separators=(',',':'))
#print(jd)

#request get for api
r = requests.post('https://api.reg.ru/api/regru2/zone/get_resource_records?input_data='+jd+'&input_format=json')
#or post
if r.status_code != 200:
  print('bye')
  exit()

#print(r.text)

#connection success
#check status
b = json.loads(r.text)
#print(b)
if b['result'] == 'error':
  print('something wrong')
  exit()

#check neded records
print('')

exists = []
for rec in b['answer']['domains'][0]['rrs']:
  if rec['rectype'] == 'CNAME':
    exists.append(rec['subname'])
print('reg.ru records:', exists)

action_list = []
to_add = []
for sn in subnames:
  if not sn in exists:    
    to_add.append(sn)
    action_list.append({'action':'add_cname', 'subdomain':sn, 'canonical_name': domain})
print('will be added:', to_add)

to_remove = []
for sn in exists:
  if not sn in subnames:
    to_remove.append(sn)
    #action_list.appen({})
print('will be removed:', to_remove)   
  
print('starting')
#ADD RECORDS
for sn in to_add:
  input_data={
    "username": username,
    "password": password,
    "domains":[
      {"dname": domain}
    ],
    "subdomain": sn,
    "canonical_name": domain,
    "output_content_type":"plain"
  }
  jd = json.dumps(input_data,separators=(',',':'))
  #print(json.dumps(input_data, indent=2))
  r = requests.post('https://api.reg.ru/api/regru2/zone/add_cname?input_data='+jd+'&input_format=json')
  print(r.status_code)
  print(r.text)

#REMOVE RECORDS    
for sn in to_remove:
  input_data={
    "username": username,
    "password": password,
    "domains":[
      {"dname": domain}
    ],
    "subdomain": sn,
    "record_type": "CNAME",
    "output_content_type":"plain"
  }
  jd = json.dumps(input_data,separators=(',',':'))
  #print(json.dumps(input_data, indent=2))
  r = requests.post('https://api.reg.ru/api/regru2/zone/remove_record?input_data='+jd+'&input_format=json')
  print(r.status_code)
  print(r.text)  

