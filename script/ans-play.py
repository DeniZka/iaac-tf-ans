#!/usr/bin/python3
import sys
import os

pbdir = os.environ["ANSIBLE_PLAYBOOK_DIR"]
last_ch = os.environ["SCRIPT_PLAY_LAST_CHOSEN"]

if len(sys.argv) > 1:
  #check playbook selected correctly
  pb = sys.argv[1]
  if not '.yml' in pb:
    pb = pb + '.yml'
  
  os.system('ansible-playbook ' + os.path.join(pbdir, pb))
  exit()
  
#no playbook selected. parse
fl = os.listdir(pbdir)
pl = []
for fn in fl:
  if '.yml' in fn:
    pl.append(fn)

pl.sort()

print("Choose you playbook:")
for i in range(len(pl)):
  print('[' + str(i) + ']: ', pl[i])
sel = input('Return for last selected [' + last_ch + ']: ')
if not sel:
  sel = last_ch

if sel != last_ch:
  print(sel)
  os.system('sed -ri \'s/SCRIPT_PLAY_LAST_CHOSEN=[[:digit:]]+/SCRIPT_PLAY_LAST_CHOSEN=' + pl[int(sel)] + '/\' script/.env')
os.system('ansible-playbook ' + os.path.join(pbdir, pl[int(sel)]))


   
