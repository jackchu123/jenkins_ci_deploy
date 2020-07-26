#!/bin/sh
#
# Version cloud_2.1
# source
source /etc/profile
# fronted
ip=192.168.1.48
user=jie
password=xindeqd
# copy config
file_home=/home/sanyuanse/cloud2_1_0/sh/web_config
svn_home=/home/sanyuanse/cloud2_1_0/sh/svn_package_v2.1.4.10
zip_home=/home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/test_files
build_front=server131_web-app,server131_web-cloud-ent,server131_web-cloud-mgr
#function
function win_build(){
expect << EOF 
spawn telnet $ip 23
expect "Login username: "
send "$user\r" 
expect "Login password: "
send "$password\r"
expect "Domain name: "
send "$user\r"
expect "Authentication is in progress..."
send "cd /d D:git_cloud2.1/front_bat && $1.bat\r"
expect "D:\git_cloud2.1\qccvas-frontend\web-cloud-ent>"
send "dir"
EOF
}
function web_pg(){
while [ ! -f $file_home/$1.zip ]
do
    echo wait 20s
    sleep 20
done
}
function upload(){
    # svn update
    cd $svn_home
    svn update
    # cp file
    #APP=`ls $svn_home/$1/$2.zip|awk -F'/' '{print $NF}'`
    if [ ! -f $svn_home/$1/$2.zip ] 
    then
        ls $file_home/$2.zip|xargs -i cp {} $1/
        cd $1/
        svn add $2.zip
        svn commit -m "svn upload"
    else
        ls $file_home/$2.zip|xargs -i cp {} $1/
        cd $1/
        svn commit -m "svn upload"
    fi
}
function app_upload(){
    # zip file
    [ -d /tmp/test_file ] && rm -rf /tmp/test_file 
    [ -d /tmp/web-app ] && rm -rf /tmp/web-app
    mkdir -p /tmp/test_file && mkdir -p /tmp/web-app
    mv $file_home/web-app.zip /tmp/test_file/
    cd /tmp/test_file && unzip web-app.zip && rm web-app.zip 
    dirfile=`ls`
    for i in $dirfile
    do
        cd $i
        zip -q -r $i.zip ./
        mv $i.zip /tmp/web-app/
        cd ../
    done
    cd /tmp
    zip -r web-app.zip web-app/
    # svn update
    cd $svn_home
    svn update
    # cp file
    #APP=`ls $svn_home/$1/web-app.zip`
    if [ ! -f $svn_home/$1/web-app.zip ]
    then
        cp /tmp/web-app.zip $svn_home/$1 
        cd $1/
        svn add web-app.zip
        svn commit -m "svn upload"
    else
        cp /tmp/web-app.zip $svn_home/$1 
        cd $1/
        svn commit -m "svn upload"
    fi 
    # app update
    if [ -f $zip_home/appupdate_list.txt ]
    then
        zip_name=$(cat $zip_home/appupdate_list.txt)
        for name in $zip_name
        do
            if [ -z $name ]
            then
                echo No Package
            else
                if [ -f /tmp/web-app/$name.zip ]
                then
                    if [ ! -f $svn_home/$1/$name.zip ]
                    then
                        cp /tmp/web-app/$name.zip $svn_home/$1/
                        cd $svn_home/$1
                        svn add $name.zip
                        svn commit -m "svn upload"
			cp /tmp/web-app/$name.zip $zip_home/zipfile
                    else
                        cp /tmp/web-app/$name.zip $svn_home/$1/
                        cd $svn_home/$1
                        svn commit -m "svn upload"
			cp /tmp/web-app/$name.zip $zip_home/zipfile
                    fi
                else
                    echo ========$name.zip name error===========
                fi
            fi
        done
        
    else
        echo No Package
    fi

}
# deploy
if [ -z $build_front ]
then
    echo No Front file
else
    for name in $(echo $build_front | sed "s/,/ /g")
    do
        if [ "$name" == server115_web-app ]; then
    	    #win_build $name
    	    ## check package
            #web_pg web-app
            app_upload ALET 
        elif [ "$name" == server115_web-cloud-mgr ]; then
    	    #win_build $name
    	    ## check package
            #web_pg web-cloud-mgr
            upload BMPW web-cloud-mgr 
        elif [ "$name" == server115_web-download ]; then
    	    #win_build $name
    	    ## check package
            #web_pg web-cloud-mgr
            upload BMPW web-download
        elif [ "$name" == server115_web-cloud-ent ]; then
    	    #win_build $name
    	    ## check package
            #web_pg web-cloud-ent
            upload BCPW web-cloud-ent
        elif [ "$name" == server131_web-app ]; then
    	    #win_build $name
    	    ## check package
            #web_pg web-app
            app_upload ALET   
        elif [ "$name" == server131_web-cloud-mgr ]; then
    	    #win_build $name
    	    ## check package
            #web_pg web-cloud-mgr
            upload BMPW web-cloud-mgr
        elif [ "$name" == server131_web-download ]; then
    	    #win_build $name
    	    ## check package
            #web_pg web-cloud-mgr
            upload BMPW web-download
        elif [ "$name" == server131_web-cloud-ent ]; then
    	    #win_build $name
    	    ## check package
            #web_pg web-cloud-ent
            upload BCPW web-cloud-ent
	else
	    echo no package
	fi
    done
fi
