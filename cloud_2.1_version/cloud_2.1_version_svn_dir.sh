#!/bin/sh
#
# Version cloud_2.1
# config
err_test=2.1.4.10
svn_home=/home/sanyuanse/cloud2_1_0/sh/svn_package_v2.1.4.10
sh_home=/home/sanyuanse/cloud2_1_0/sh
git_name=test
# profile
source /etc/profile
## deploy
# svn dir check
if [ -z $err_test ]
then
    echo Please input version
else
    if [ -d $svn_home ]
    then
        echo cannot create directory svn_package_v2.1.4.10: File exists
    else
        if [ "$git_name" == hotfix ]
 	then 
            cd $sh_home && mkdir svn_package_v2.1.4.10
            cd svn_package_v2.1.4.10 
	    url_txt='http://192.168.1.120:8080/svn/Product/Cloud2.1/04_Test/4.3%20ST/2.1.4.10'
            svn checkout $url_txt ./ --username=chuweiqi --password=jackchu@123
	else
	    cd $sh_home && mkdir svn_package_v2.1.4.10
            cd svn_package_v2.1.4.10
            url_txt='http://192.168.1.120:8080/svn/Product/QCCVAS/01_CI/1.5_Test/1.5.3_STP&STC/2.1.4/2.1.4.10'
            svn checkout $url_txt ./ --username=chuweiqi --password=jackchu@123
            # private dir 
            cd $sh_home/svn_private && mkdir 2.1.4.10
	fi
    fi
fi
