#!/bin/bash

#/update centos/

echo  "date +'%H:%M:%S' - start yum update ">> /tmp/logs.out

 yum update -y

#insall githup
echo  "date +'%H:%M:%S' - install git wget ">> /tmp/logs.out

 yum install git wget -y

#install httpd
echo  "date +'%H:%M:%S' - install httpd ">> /tmp/logs.out

 yum install httpd -y

#start and enable httpd
 systemctl start httpd
 systemctl enable httpd

#insall php
echo  "date +'%H:%M:%S' - install php ">> /tmp/logs.out
 yum install yum-utils -y
 yum install epel-release -y --skip-broken
 yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
 yum-config-manager --enable remi-php70
 yum-config-manager --enable remi-php71
 
 yum install php php-common php-opcache php-mcrypt php-cli php-gd php-curl php-mysql php-mysqli -y --skip-broken

#opne file html
rm -rf /var/www/html/*

mkdir -p /var/www/html
echo  "date +'%H:%M:%S' - clone repo ">> /tmp/logs.out

git clone https://github.com/Ahmad-Faqehi/Locker_System.git  /var/www/html

#insall nano
 yum install nano -y

echo  "date +'%H:%M:%S' - install  mysql clinet and import db ">> /tmp/logs.out
export new_db_endpoint=$(echo ${db_endpoint} | sed "s/:3306//")
export MYSQL_PWD="${db_pass}"
dnf install mariadb105 -y
echo $new_db_endpoint > /tmp/db_endpoint.txt

sed -i "s/localhost/$new_db_endpoint/g; s/root/${db_user}/g; s/123321/${db_pass}/g; s/lockers/${db_name}/g" /var/www/html/app/inc/conf.php

systemctl restart httpd
mysql -u ${db_user}   -h $new_db_endpoint  -p ${db_name} < /var/www/html/db/lockers_v4.sql

echo  "date +'%H:%M:%S' - *   Finsih ::::)))))    * ">> /tmp/logs.out
