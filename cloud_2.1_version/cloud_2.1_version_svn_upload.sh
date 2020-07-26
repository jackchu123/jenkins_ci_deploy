#!/bin/sh
#
# Version cloud_2.1
# source
svn_home=/home/sanyuanse/cloud2_1_0/sh/svn_package_v2.1.4.10
#code_home=jenkins_background_file
#package_home=package_name
sh_home=/home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version
# profile
source /etc/profile
# func svn
function upload(){
    # svn update
    cd $svn_home
    svn update
    # cp file
    APP=`ls /home/sanyuanse/cloud2_1_0/$2/*.jar|awk -F'/' '{print $NF}'`
    if [ ! -f $1/$APP ] 
    then
        ls /home/sanyuanse/cloud2_1_0/$2/*.jar|xargs -i cp {} $1/
        cd $1/
        svn add $APP
        svn commit -m "svn upload"
    else
        ls /home/sanyuanse/cloud2_1_0/$2/*.jar|xargs -i cp {} $1/
        cd $1/
        svn commit -m "svn upload"
    fi
}
function upload_file(){
    # svn update
    cd $svn_home
    svn update
    # cp file
    APP=`ls /home/sanyuanse/cloud2_1_0/basefile/$2/*.jar|awk -F'/' '{print $NF}'`
    if [ ! -f $1/$APP ] 
    then
        ls /home/sanyuanse/cloud2_1_0/basefile/$2/*.jar |xargs -i cp {} $1/
        cd $1/
        svn add $APP
        svn commit -m "svn upload"
    else
        ls /home/sanyuanse/cloud2_1_0/basefile/$2/*.jar |xargs -i cp {} $1/
        cd $1/
        svn commit -m "svn upload"
    fi
}
function upload_svn(){
    if [ "$name" == manager ]; then
        upload BMPS $1
    elif [ "$name" == statistics ]; then
        upload BCPS $1
    elif [ "$name" == user ]; then
        upload BCPS $1
    elif [ "$name" == code ]; then
        upload BCPS $1
    elif [ "$file_name" == manager ]; then
        upload_file BMPS manager $1
    elif [ "$name" == log ]; then
        upload BCPS $1
    elif [ "$file_name" == public ]; then
        upload_file BMPS public $1
    elif [ "$name" == message ]; then
        upload BCPS $1
    elif [ "$name" == tenant ]; then
        upload BCPS $1
    elif [ "$name" == base ]; then
        upload BCPS $1
    elif [ "$name" == goods ]; then
        upload BCPS $1
    elif [ "$name" == order ]; then
        upload BCPS $1
    elif [ "$name" == scheduled ]; then
        upload BCPS $1
    elif [ "$name" == scan-manager ]; then
        upload SCAN $1
    elif [ "$name" == scan-service ]; then
        upload SCAN $1
    else 
        echo no project
    fi
}
function svn_deploy(){
    for name in $svn_name
    do
        if [ -z $name ]
        then
            echo No Package
        else
            upload_svn $name
        fi
    done
}
function svn_file_deploy(){
    for file_name in $svn_file_name
    do
        if [ -z $file_name ]
        then
            echo No Package
        else
            upload_svn $file_name
        fi
    done
}
# upload package
## deploy
if [ -f $sh_home/svn_name.txt ]
then
    svn_name=$(cat $sh_home/svn_name.txt)
    svn_deploy
    sleep 5
    rm $sh_home/svn_name.txt
    echo v2.1.4.10 >> $sh_home/svn_update_version.txt 
else
    echo No Package
fi
if [ -f $sh_home/svn_file_name.txt ]
then
    svn_file_name=$(cat $sh_home/svn_file_name.txt)
    svn_file_deploy
    sleep 5
    rm $sh_home/svn_file_name.txt
    echo v2.1.4.10 >> $sh_home/svn_update_version.txt
else
    echo No Package
fi
