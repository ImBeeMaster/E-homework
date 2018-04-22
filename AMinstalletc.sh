#! /usr/bin/env bash

#######################         Little instruction       ################################
#  Script behaviour:                                                                    #
#  Input options are to be separated with space, not separated options aren\'t currenty #
#  recognisable.                                                                        #
#  The script supports following options:                                               #
#  -a   Install apache only                                                             #
#  -m   Install mysql(mariadb) only                                                     #
#  -n   Set name for web host                                                           #
#  -h,--h Show help                                                                     #
#  -p   Set a port for mysql server                                                     #
#       Error status:                                                                   #
#       2, Bad argument                                                                 #
#       3, Conflict arguments                                                           #
#       4, The package is already installed                                             #
#########################################################################################

instM=0     #default values responsible for installation type
instA=0     #default values responsible for installation type

helpf () {
echo -e "Input options are to be separated with space, not separated options aren't currenty 
   recognisable.                                                                        
   The script supports following options:                                               
   -a   Install apache only                                                             
   -m   Install mysql(mariadb) only                                                     
   -n   Set name for web host                                                           
   -p   Set a port for mysql server
   -h,--h Show help
"
}

if [[ $# -ne 0  ]]; then
while [[ $# != 0 ]]
do
    case $1 in
    -n) if [[ ! `echo "${*}" | grep -e '-m'` ]]; then echo "Input a hostname"; read -r; #<Check is option -m is not included
        hostn=$REPLY                                                                    #<Input a hostname for a web server
            if [[ -n ${hostn} ]];then
        echo "You have set the web server with the following hostname: ${hostn}"
            else echo 'Plese make up some hostname'; exit 2
             fi

    fi
    ;;
    -m) if [[ `echo "${*}" |  grep -e '-a'` ]]  #Check is there no controversial arguments
                then
                echo "Error in input string, -m can\`t be used with -a"
                exit 3
                fi
        instM=1                 #installation variable
                                #install mysql only
        echo "'m' ${instM} argument provided" ##< To be deleted after debugging
    ;;

    -a) if [[ `echo "${*}" | grep -e '-m'` ]]  #Check is there no controversial arguments
        then
        echo "Error in input string, -a can\`t be used with -m"
        exit 3
        fi            
        instA=1         #isntallation variable
                        #install apache only
    ;;
    --help|-h) echo 'Help'
        helpf                           #print help info
        exit
    ;;
    -p) portname=$2
        if [[ ! `echo "${portname}" | grep -E "\b[0-9]+\b"` ]]; then echo "Please, specify a valid port"; exit 2; fi
        shift
    ;;
     *) echo 'Error, unknown argument provided'
        exit 2
        ;;

    esac
    shift
done
fi

Ainstall () {            #apache installation function
    echo "startiong installation httpd"
    sudo yum install -y httpd 2>>hail.log 1>/dev/null
    if [[ $? -ne 0 ]]; then date >> hail.log
        echo '' >> hail.log; exit
    fi
    [[ -d /var/www ]] && sudo chown -R apache:apache /var/www #<check the directory to be existed
    if [[ $? -ne 0 ]]; then echo "Couldn't change the owner"; fi
    if [[ -e /etc/httpd/conf/httpd.conf ]]; then
        sed -i "s/Listen .*$/Listen ${portname:-1233}/" /etc/httpd/conf/httpd.conf  #<a parameter here for port to be specified
        else echo 'For some reason a configuration file wasn\`t found' | tail >> date >> hail.log
        echo '' >> hail.log
    fi
    sudo systemctl enable httpd.service
    sudo systemctl start httpd.service
    if [[ -n $hostname ]] && [[ ! `grep ${hostn} /etc/host` ]]; then 
    echo "127.0.0.1 ${hostn}" >> /etc/hosts
    fi
}

Minstall () {          #mysql installation function
echo "startiong installation mysql"
    sudo yum install -y mysql mariadb-server 2>>hail.log 1>/dev/null #<add exit status to the log
    if [[ $? -ne 0 ]]; then date >> hail.log
        echo '' >> hail.log; exit
    fi
    [[ -d /var/lib/mysql ]] && sudo chown -R mysql:mysql /var/lib/mysql #<check the directory to be existed
    if [[ $? -ne 0 ]]; then echo "Couldn't change the owner"; fi
    sudo systemctl enable mariadb.service
    sudo systemctl start mariadb.service
}
   
#actually installation part


if [[ $instM -eq 0 ]] && [[ $instA -eq 0 ]]; then
    yum list installed mariadb-server 2>&1 1>/dev/null
    statusM1=$?
    yum list installed mariadb 2>&1 1>/dev/null
    statusM2=$?
    yum list installed httpd 2>&1 1>/dev/null
    statusA=$?
    if [[ $statusM1 -eq 0 ]] && [[ $statusM2 -eq 0 ]] && [[ $statusA -eq 0 ]]
        then echo 'httpd and mysql is already installed' && exit 4
    fi
    Minstall
    Ainstall
    elif [[ $instM -eq 1 ]];
        then
        yum list installed mariadb-server 2>&1 1>/dev/null
        statusM1=$?
        yum list installed mariadb 2>&1 1>/dev/null
        statusM2=$?
        [[ $statusM1 -eq 0 ]] && [[ $statusM2 -eq 0 ]] && echo 'Mysql is already installed' && exit 4;
        Minstall
    elif [[ $instA -eq 1 ]];
        then
        yum list installed httpd 2>&1 1>/dev/null
        [[ $? -eq 0 ]] && echo 'httpd is already installed' && exit 4
        Ainstall
    else echo "Something weird have happend, installation didn't occur"
fi