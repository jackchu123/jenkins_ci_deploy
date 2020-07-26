#!/bin/sh
#
# Version cloud_2.1
# source
cloud_home=/home/sanyuanse/cloud2_1_0
svn_home=/home/sanyuanse/cloud2_1_0/sh/svn_package_2.1.4
front_home=/home/sanyuanse/cloud2_1_0/sh/web_config
# backend pg name
pg_name=manager,statistics,user,code,basefile/manager,log,basefile/public,message,tenant,base,goods,order,scheduled
front_name=web-cloud-ent,web-cloud-mgr,web-download,web-app
end_version=2.1.4.7
start_version=2.1.4.4
# code
code_home=/home/sanyuanse/cloud2_1_0/sh/svn_code_2.1.4
project_home=/home/sanyuanse/cloud2_1_0
#function
function upload(){
cd $cloud_home/$pg
APP=`ls *.jar`
cp $APP $svn_home/base$end_version/$1/
#cd $svn_home/base$end_version/$1/
#svn add $APP
#svn commit -m "svn upload"
}
function front_upload(){
cp $2/$3.zip $svn_home/base$end_version/$1/
#cd $svn_home/base$end_version/$1/
#svn add $name.zip
#svn commit -m "svn upload"
}
# profile
source /etc/profile
# deploy
# file
if [ -z base$end_version ]
then
    echo please input end version
else
    if [ -d $svn_home/base$end_version ] 
    then
        echo cannot create directory base$end_version: File exists
    else
        ## svn dir
	echo ===============svn create=========
        cp -rf $cloud_home/sh/svn_package_tem $svn_home/base$end_version
        cd $svn_home
        #svn add base$end_version
        #svn commit -m "svn upload"
        ## backend
	#echo ===============backend cp========
        #for pg in $(echo $pg_name | sed "s/,/ /g")
        #do
    	#    if [ "$pg" == manager ]; then
    	#        upload BMPS
    	#    elif [ "$pg" == basefile/manager ]; then
    	#        upload BMPS
    	#    elif [ "$pg" == basefile/public ]; then
    	#        upload BMPS
    	#    else
    	#        upload BCPS
    	#    fi
        #done
	## base cp
	#echo =============base package cp=============
	#if [ -z $start_version ]; then
        #    echo pleasr input start version
        #else
        #    cd $cloud_home/sh
        #    start_num=`echo $start_version|awk -F'.' '{print $NF}'`
        #    end_num=`echo base$end_version|awk -F'.' '{print $NF}'`
        #    for num in `seq $start_num $end_num`
        #    do
        #        # cp
	#	echo svn_package_v2.1.4.$num cp 
	#	cp -r svn_package_v2.1.4.$num/* $svn_home/base$end_version/
        #    done
        #fi
        ## front
	#echo ============front cp==============
        #for name in $(echo $front_name | sed "s/,/ /g")
        #do
    	#    if [ "$name" == web-cloud-ent ]; then
    	#        front_upload BCPW $front_home $name
    	#    elif [ "$name" == web-app ]; then
    	#        front_upload ALET /tmp/test_file $name
    	#    else
    	#        front_upload BMPW $front_home $name
    	#    fi
        #done
        ## sql
	echo ============sql cp================
        if [ -z $start_version ]; then
    	    echo pleasr input start version
        else
    	    cd $cloud_home/sh
    	    start_num=`echo $start_version|awk -F'.' '{print $NF}'`
    	    end_num=`echo base$end_version|awk -F'.' '{print $NF}'`
    	    for num in `seq $start_num $end_num`
    	    do
                #pwd
		cd $cloud_home/sh/
    	        # mysql
    	        [ -f svn_package_v2.1.4.$num/BCPS/tenant.sql ]  && cp svn_package_v2.1.4.$num/BCPS/tenant.sql $svn_home/base$end_version/BCPS/tenant_v2.1.4.$num.sql
    	        [ -f svn_package_v2.1.4.$num/BCPS/environment.sql ]  && cp svn_package_v2.1.4.$num/BCPS/environment.sql $svn_home/base$end_version/BCPS/environment_v2.1.4.$num.sql
    	        [ -f svn_package_v2.1.4.$num/BMPS/manager.sql ]  && cp svn_package_v2.1.4.$num/BMPS/manager.sql $svn_home/base$end_version/BMPS/manager_v2.1.4.$num.sql
    	        # mongo
    	        [ -f svn_package_v2.1.4.$num/BCPS/mongodb.js ]  && cp svn_package_v2.1.4.$num/BCPS/mongodb.js $svn_home/base$end_version/BCPS/mongodb_v2.1.4.$num.js
    	    done
        fi
        ### code
	#echo ============code cp===============
	#if [ -d $code_home/code$end_version ]
	#then
	#    echo code version file exist
	#else
	#    # dir create
	#    cd $code_home
	#    mkdir code$end_version
	#    # code update
        #    cd $project_home
        #    for code in {qccvas-backend,qccvas-kernel,qccvas-frontend}
        #    do
    	#        rm -rf $code
    	#        git clone -b test ssh://git@gitlab.qccvas.com:222/yuweijia/$code.git
    	#        tar -zcf $code.tar.gz $code
    	#        cp $code.tar.gz $code_home/base$end_version/
	#	rm $code.tar.gz
    	#        #cd $code_home/base$end_version/
    	#        #svn add $code.tar.gz
    	#        #svn commit -m "svn upload"
        #    done
	#    cd $code_home
	#    svn add code$end_version
        #    svn commit -m "svn upload"
	#fi
	#cd  $svn_home
	#svn add base$end_version
        #svn commit -m "svn upload"
    fi
fi
