#!/bin/sh
#
# Version cloud_2.1
# source
source /etc/profile
# config
ACTIVE=fat
project_home=/home/sanyuanse/cloud2_1_0
#deploy
cd $project_home
rm -rf qccvas-backend
rm -rf qccvas-kernel
git clone -b test ssh://git@gitlab.qccvas.com:222/yuweijia/qccvas-backend.git
git clone -b test ssh://git@gitlab.qccvas.com:222/yuweijia/qccvas-kernel.git
