#!/usr/bin/bash
#get main page with version info
wget "https://dev.mysql.com/downloads/repo/apt/"
#grab filename
fv=`grep -E -o 'mysql-apt.*?\.deb' index.html | head -1`
#replace variable 
sed -i "s/mysql-.*/$fv/" $ANSIBLE_ROLES_PATH/mysql/vars/main.yml
#remove trash
rm -rf index.html
