#! /usr/bin/env bash

yum install -y httpd 2>&1 1>/dev/null
    if [[ $? -ne 0 ]]; then date >> hail.log
        echo '' >> hail.log
    fi
yum install -y mysql mariadb-server 2>&1 1>/dev/null #<add exit status to the log
    if [[ $? -ne 0 ]]; then date >> hail.log
        echo '' >> hail.log
    fi
echo '127.0.0.1 readyplayerone.com' #<should add content check
        
        
    if [[ -e /etc/httpd/conf/httpd.conf ]]; then
    #this should be parsed with sed: /etc/httpd/conf/httpd.conf
    ##should add parse for server name
        sed -i "s/Listen/Listen 8080/" /etc/httpd/conf/httpd.conf #<can use postional parameter here for port to be specified
    else echo 'For some reason a configuration file wasn\`t found' | tail >> date >> hail.log
        echo '' >> hail.log
    fi
 chown -R myqsl:myqsl /var/lib/mysql #<check the directory to be existed
 chown -R apache:apache /var/www #<check the directory to be existed
 systemctl enable httpd.service
 systemctl start httpd.service
 systemctl enable httpd.service
 systemctl start mariadb.service
