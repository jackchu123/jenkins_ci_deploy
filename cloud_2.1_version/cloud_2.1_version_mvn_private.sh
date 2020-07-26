#!/bin/sh
#
# Version cloud_2.1
# source
source /etc/profile
# config
ACTIVE=fat
project_home=/home/sanyuanse/cloud2_1_0/qccvas-backend
mvn_home=/home/sanyuanse/cloud2_1_0/qccvas-kernel
#sh_home=/home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version
branch=test
code_home=qccvas-biz-statistics,qccvas-biz-user,qccvas-biz-code,qccvas-base-log,qccvas-base-file,qccvas-base-message,qccvas-base-tenant,qccvas-biz-base,qccvas-biz-goods,qccvas-biz-order,qccvas-base-scheduled,qccvas-biz-scan
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
    # cp file
    # porcess pid 
    #pid=`pgrep -f $name`
    # kill process
    #[[ $pid ]] && kill -9 $pid
    ## remove old package
    #cp /home/sanyuanse/cloud2_1_0/$3/*.jar /home/sanyuanse/cloud2_1_0/$3/*.jar.bak
    #rm /home/sanyuanse/cloud2_1_0/$3/*.jar
    ## process config
    #port=$2
    #JAVA_OPTS="-XX:MetaspaceSize=256m -XX:MaxMetaspaceSize=512m -Xms2048m -Xmx2048m -Xmn512m -Xss256k -XX:SurvivorRatio=8 -XX:+UseConcMarkSweepGC"
    ## mv package
    #mv $project_home/$name/$1/target/*.jar /home/sanyuanse/cloud2_1_0/$3/
    ## start process
    #APP=`ls /home/sanyuanse/cloud2_1_0/$3/*.jar`
    #nohup java -jar $JAVA_OPTS $APP --server.port=$port --spring.profiles.active=$ACTIVE > /home/sanyuanse/cloud2_1_0/$3/$3.out 2>&1 &
    ## svn name
    #echo $3 >> $sh_home/svn_name.txt
    #echo $3 >> $sh_home/svn_update_version.txt
}

function scan_upload(){
    cd $project_home
    git checkout $branch;
    git pull origin $branch;
    ## mvn package
    cd $project_home/qccvas-biz-scan/
    mvn clean install -Dmaven.test.skip=true;
    ## porcess pid 
    #pid=`pgrep -f $name`
    ## kill process
    #[[ $pid ]] && kill -9 $pid
    ## remove old package
    #cp /home/sanyuanse/cloud2_1_0/$3/*.jar /home/sanyuanse/cloud2_1_0/$3/*.jar.bak
    #rm /home/sanyuanse/cloud2_1_0/$3/*.jar
    ## process config
    #port=$2
    #JAVA_OPTS="-XX:MetaspaceSize=256m -XX:MaxMetaspaceSize=512m -Xms2048m -Xmx2048m -Xmn512m -Xss256k -XX:SurvivorRatio=8 -XX:+UseConcMarkSweepGC"
    ## mv package
    #mv $project_home/qccvas-biz-scan/$1/target/*.jar /home/sanyuanse/cloud2_1_0/$3/
    ## start process
    #APP=`ls /home/sanyuanse/cloud2_1_0/$3/*.jar`
    #nohup java -jar $JAVA_OPTS $APP --server.port=$port --spring.profiles.active=$ACTIVE > /home/sanyuanse/cloud2_1_0/$3/$3.out 2>&1 &
    ## svn name
    #echo $3 >> $sh_home/svn_name.txt
    #echo $3 >> $sh_home/svn_update_version.txt
}

function file_upload(){
    cd $project_home
    git checkout $branch;
    git pull origin $branch;
    ## mvn package
    cd $project_home/qccvas-base-file/
    mvn clean install -Dmaven.test.skip=true;
    ## porcess pid
    #pid=`pgrep -f $name`
    ## kill process
    #[[ $pid ]] && kill -9 $pid
    ## remove old package
    #cp /home/sanyuanse/cloud2_1_0/basefile/$1/*.jar /home/sanyuanse/cloud2_1_0/basefile/$1/*.jar.bak
    #rm /home/sanyuanse/cloud2_1_0/basefile/$1/*.jar
    ## process config
    #port=$2
    #JAVA_OPTS="-XX:MetaspaceSize=256m -XX:MaxMetaspaceSize=512m -Xms2048m -Xmx2048m -Xmn512m -Xss256k -XX:SurvivorRatio=8 -XX:+UseConcMarkSweepGC"
    ## mv package
    #mv $project_home/qccvas-base-file/$name/target/*.jar /home/sanyuanse/cloud2_1_0/basefile/$1/
    ## start process
    #APP=`ls /home/sanyuanse/cloud2_1_0/basefile/$1/*.jar`
    #nohup java -jar $JAVA_OPTS $APP --server.port=$port --spring.profiles.active=$ACTIVE > /home/sanyuanse/cloud2_1_0/basefile/$1/$1.out 2>&1 &
    ## svn name
    #echo $1 >> $sh_home/svn_file_name.txt
    #echo file_$1 >> $sh_home/svn_update_version.txt
}
# updata backgound
if [ -z $code_home ]
then
    echo No Package update
else
    mvn_depend
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
            upload 
        elif [ "$name" == qccvas-base-message ]; then
            upload 
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
