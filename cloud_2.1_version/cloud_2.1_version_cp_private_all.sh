#!/bin/sh
#
# Version cloud_2.1
# source
source /etc/profile
# config
project_home=/home/sanyuanse/cloud2_1_0/qccvas-backend
code_home=qccvas-biz-statistics,qccvas-biz-user,qccvas-biz-code,qccvas-base-log,qccvas-base-file,qccvas-base-message,qccvas-base-tenant,qccvas-biz-base,qccvas-biz-goods,qccvas-biz-order,qccvas-base-scheduled
# function
function upload(){
    ## mvn package
    cd $project_home/$name/
    private_name=`echo $name|cut -d "-" -f 3`
    cp $private_name-private-starter/target/*.jar /home/sanyuanse/cloud2_1_0/qcc-file/
    echo $private_name
}

function log_upload(){
    ## mvn package
    cd $project_home/$name/
    private_name=`echo $name|cut -d "-" -f 3`
    cp $private_name-private/target/*.jar /home/sanyuanse/cloud2_1_0/qcc-file/
    echo $private_name
}
# updata backgound
if [ -z $code_home ]
then
    echo No Package update
else
    for name in $(echo $code_home | sed "s/,/ /g")
    do
        if [ "$name" == qccvas-biz-manager ]; then
            upload 
        elif [ "$name" == qccvas-biz-statistics ]; then
            upload 
        elif [ "$name" == qccvas-biz-user ]; then
            upload 
        elif [ "$name" == qccvas-biz-code ]; then
            upload 
        elif [ "$name" == qccvas-base-file ]; then
            upload 
        elif [ "$name" == qccvas-base-log ]; then
            log_upload 
        elif [ "$name" == qccvas-base-message ]; then
            cp $project_home/qccvas-base-message/message/target/qccvas-base-message-2.1.0-SNAPSHOT.jar /home/sanyuanse/cloud2_1_0/qcc-file/
        elif [ "$name" == qccvas-base-tenant ]; then
            upload 
        elif [ "$name" == qccvas-biz-base ]; then
            upload 
        elif [ "$name" == qccvas-biz-goods ]; then
            upload 
        elif [ "$name" == qccvas-biz-order ]; then
            upload 
        elif [ "$name" == qccvas-base-scheduled ]; then
            upload 
        elif [ "$name" == qccvas-biz-scan ]; then
            scan_upload 
        else 
            echo no project
        fi
    done
fi
