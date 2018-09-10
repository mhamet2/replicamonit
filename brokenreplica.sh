#!/bin/bash

DATE=`date +%Y%m%d%H%M` 
SCRIPT=`dirname $0`/`basename $0 .sh` 
 
exec 1>> ${SCRIPT}_${DATE}.log 
exec 2>> ${SCRIPT}_${DATE}.err 

MYSQLPATH='/bin/mysql'
SECONDS_BEHIND_MASTER=`$MYSQLPATH -e "SHOW SLAVE STATUS\G" | grep "Seconds_Behind_Master" | awk -F ": " {'print $2'} `

function drop_packets {

 if [ `/sbin/iptables -L -n -v | grep -i -E "DROP.*3306" | wc -l` -eq "0" ]; then  

    /sbin/iptables -A INPUT -p tcp --destination-port 3306 -j DROP
    /sbin/iptables-save
 fi

}

#SECONDS_BEHIND_MASTER="121"

if [ "$SECONDS_BEHIND_MASTER" -ge "120" ]; then
      
   drop_packets
      
fi
