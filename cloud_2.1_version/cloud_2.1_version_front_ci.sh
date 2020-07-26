#!/bin/sh
#
# Version cloud_2.1
# config
svn_home=/home/sanyuanse/cloud2_1_0/sh/svn_package_v2.1.4.10
front_file=web-cloud-ent,web-cloud-mgr
# profile
source /etc/profile
## frontend
## cp file
if [ -z $front_file ]
then
    echo No Front file
else
    ## download zip
    cd $svn_home
    svn update
    for name in $(echo $front_file | sed "s/,/ /g")
    do
        if [ "$name" == web-cloud-ent ]; then
            #url_txt='http://192.168.1.120:8080/svn/Product/QCCVAS/01_CI/1.5_Test/1.5.3_STP&STC/2.1.3/2.1.3.2/BCPW/web-cloud-ent.zip'
            #wget -P /home/sanyuanse/cloud2_1_0/sh/web_config/ $url_txt --user=chuweiqi --password=jackchu@123
            cp -rf /home/sanyuanse/cloud2_1_0/web/public /home/sanyuanse/cloud2_1_0/web/public.bak
            rm -rf /home/sanyuanse/cloud2_1_0/web/public/*
            unzip BCPW/web-cloud-ent.zip -d /home/sanyuanse/cloud2_1_0/web/public/
            # change config
            cp /home/sanyuanse/cloud2_1_0/sh/web_config/ent_index.js /home/sanyuanse/cloud2_1_0/web/public/static/config/index.js
            # private cp
            cp BCPW/web-cloud-ent.zip /home/sanyuanse/cloud2_1_0/sh/svn_private/v2.1.4.10/
        elif [ "$name" == web-cloud-mgr ]; then
            #url_txt='http://192.168.1.120:8080/svn/Product/QCCVAS/01_CI/1.5_Test/1.5.3_STP&STC/2.1.3/2.1.3.2/BMPW/web-cloud-mgr.zip'
            #wget -P /home/sanyuanse/cloud2_1_0/sh/web_config/ $url_txt --user=chuweiqi --password=jackchu@123
            cp -rf /home/sanyuanse/cloud2_1_0/web/manager /home/sanyuanse/cloud2_1_0/web/manager.bak
            rm -rf /home/sanyuanse/cloud2_1_0/web/manager/*
            unzip BMPW/web-cloud-mgr.zip -d /home/sanyuanse/cloud2_1_0/web/manager/
            # change config
            cp /home/sanyuanse/cloud2_1_0/sh/web_config/mgr_index.js /home/sanyuanse/cloud2_1_0/web/manager/static/config/index.js
            # private cp
            cp BMPW/web-cloud-mgr.zip /home/sanyuanse/cloud2_1_0/sh/svn_private/v2.1.4.10/
        elif [ "$name" == web-download ]; then
            #url_txt='http://192.168.1.120:8080/svn/Product/QCCVAS/01_CI/1.5_Test/1.5.3_STP&STC/2.1.3/2.1.3.2/BMPW/web-cloud-mgr.zip'
            #wget -P /home/sanyuanse/cloud2_1_0/sh/web_config/ $url_txt --user=chuweiqi --password=jackchu@123
            cp -rf /home/sanyuanse/cloud2_1_0/web/web-download /home/sanyuanse/cloud2_1_0/web/web-download.bak
            rm -rf /home/sanyuanse/cloud2_1_0/web/web-download/*
            unzip BMPW/web-download.zip -d /home/sanyuanse/cloud2_1_0/web/web-download/
            # change config
            cp /home/sanyuanse/cloud2_1_0/sh/web_config/dn_index.js /home/sanyuanse/cloud2_1_0/web/web-download/static/config/index.js
            # private cp
            cp BMPW/web-download.zip /home/sanyuanse/cloud2_1_0/sh/svn_private/v2.1.4.10/
        else
            echo no project
        fi
    done
fi
