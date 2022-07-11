#!/usr/bin/python3

#README: https://www.reg.ru/reseller/api2doc

import os
import json

import requests

password = 'secret'

#request get for api
r = requests.get('https://api.reg.ru/api/regru2/nop?username=grafforever@yandex.ru&password=' + password)
#or post

data = r.content().decode('utf-8')

dic = json.loads(data)


#if os.path.exists('./script/')
