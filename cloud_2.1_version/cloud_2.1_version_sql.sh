#!/bin/sh
#
# Version cloud_2.1
# config
sql_file=
svn_home=/home/sanyuanse/cloud2_1_0/sh/svn_package_v2.1.4.10
# deploy
## source sql
if [ -z $sql_file ]
then
    echo No sql file
else
    # source
    source /etc/profile
    ## download sql
    cd $svn_home
    svn update
    for name in $(echo $sql_file | sed "s/,/ /g")
    do
        if [ "$name" == tenant.sql ]
        then
	    for i in {' ',_1,_2,_3,_4,_5}
	    do
		mysql -uroot -p123456 qcc_basic$i < BCPS/tenant.sql --socket=/home/sanyuanse/mysql/mysql8/data/mysql.sock
	    done
            # private cp
	    mysql -uroot -p123456 qcc_basic_lyl < BCPS/tenant.sql --socket=/home/sanyuanse/mysql/mysql8/data/mysql.sock
            cp BCPS/tenant.sql /home/sanyuanse/cloud2_1_0/sh/svn_private/v2.1.4.10/
	elif [ "$name" == manager.sql ]; then
 	    mysql -uroot -p123456 qcc_manage < BMPS/manager.sql --socket=/home/sanyuanse/mysql/mysql8/data/mysql.sock
            # private cp
            cp BMPS/manager.sql /home/sanyuanse/cloud2_1_0/sh/svn_private/v2.1.4.10/
	elif [ "$name" == scan.sql ]; then
 	    mysql -uroot -p123456 qcc_scan < SCAN/scan.sql --socket=/home/sanyuanse/mysql/mysql8/data/mysql.sock
  	elif [ "$name" == environment.sql ]; then
	    for i in {' ',_1,_2,_3,_4,_5}
            do
                mysql -uroot -p123456 qcc_environment$i < BCPS/environment.sql --socket=/home/sanyuanse/mysql/mysql8/data/mysql.sock
            done
            # private cp
            cp BCPS/environment.sql /home/sanyuanse/cloud2_1_0/sh/svn_private/v2.1.4.10/
	else
	    echo No sql database
	fi	
    done
fi
