#!/bin/sh
#Version cloud_2.1
# config
front_home=/home/sanyuanse/cloud2_1_0/web
front_name=web-cloud-ent,web-cloud-mgr,web-download
function front_deploy(){
    cp -rf $front_home/$1 $front_home/$1.bak
    cd $front_home/$1
    rm -rf *
    cp /root/qcc-file/$name.zip ./
    unzip $name.zip
    cp $front_home/tem_js/$name.js $front_home/$1/static/config/index.js
    rm $name.zip
}
if [ -z $front_home ]; then
    echo no package update
else
    for name in $(echo $front_home | sed "s/,/ /g")
    do
        if [ "$name" == web-cloud-ent ];then
            front_deploy public
        elif [ "$name" == web-cloud-mgr ];then
            front_deploy manager
        elif [ "$name" == web-download ];then
            front_deploy web-download
        else
            echo no this package
        fi
   done
fi

