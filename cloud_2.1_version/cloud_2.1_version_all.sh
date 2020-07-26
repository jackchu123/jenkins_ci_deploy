#!/bin/sh
#
# Version cloud_2.1
# source
source /etc/profile
# config
ACTIVE=fat
project_home=/home/sanyuanse/cloud2_1_0/qccvas-backend
mvn_home=/home/sanyuanse/cloud2_1_0/qccvas-kernel
sh_home=/home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version
branch=test
code_home=qccvas-biz-manager,qccvas-biz-statistics,qccvas-biz-user,qccvas-biz-code,qccvas-base-file,qccvas-base-log,qccvas-base-message,qccvas-base-tenant,qccvas-biz-base,qccvas-biz-goods,qccvas-biz-order,qccvas-base-scheduled
# mvn depend
function mvn_depend(){
    ## kernel
    cd $mvn_home
    git checkout $branch;
    git pull origin $branch;
    for kernel_name in {root,common-core,common-test,common-sequence,common-redis,common-mongodb,common-mysql,common-kafka,common-config}
    do
        cd $mvn_home/qccvas-$kernel_name
        mvn clean install -Dmaven.test.skip=true;
    done
    ## backend
    cd $project_home
    git checkout $branch;
    git pull origin $branch;
    for backend_name in {biz-common,base-file/file-client,base-file/file-manager-client,base-message/message-client,base-tenant/tenant-client,biz-user/user-client,biz-user/auth-interceptor,biz-base/base-client,biz-code/code-client,biz-goods/goods-client,biz-manager/manager-client,biz-order/order-client,base-datasource,base-log/log-client}
    do  
        result=$(echo $backend_name | grep "/")
        if [ -n "$result" ]
        then
            cd $project_home/qccvas-${backend_name%%/*}
            mvn clean install -pl ${backend_name#*/} -am
        else
            cd $project_home/qccvas-$backend_name
            mvn clean install -Dmaven.test.skip=true;
        fi
    done
}
# function
function upload(){
    cd $project_home
    git checkout $branch;
    git pull origin $branch;
    ## mvn package
    cd $project_home/$name/
    mvn clean install -Dmaven.test.skip=true;
}

function file_upload(){
    cd $project_home
    git checkout $branch;
    git pull origin $branch;
    ## mvn package
    cd $project_home/qccvas-base-file/
    mvn clean install -Dmaven.test.skip=true;
}
# updata backgound
if [ -z $code_home ]
then
    echo No Package update
else
    mvn_depend
    for name in $(echo $code_home | sed "s/,/ /g")
    do
        upload
    done
fi
