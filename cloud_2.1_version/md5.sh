#!/bin/sh
#Version cloud_2.1
# config
code_home=manager,user,tenant,base,goods,code,order,log,statistics,scheduled,message,basefile/manager,basefile/public
#code_home=manager,user,base,goods,code,order,statistics
pg_home=/home/sanyuanse/cloud2_1_0
ip=243
# port=3401
# function 
function code_deploy(){
	cd $pg_home/$name
	pg=`ls *.jar`
	md5sum $pg
}
# deploy 
if [ -z $code_home ]; then
	echo no package update
else
	for name in $(echo $code_home | sed "s/,/ /g")
	do
		if [ "$name" == manager ];then
			code_deploy 
		elif [ "$name" == user ];then
			code_deploy 
		elif [ "$name" == tenant ];then
			code_deploy 
		elif [ "$name" == base ];then
			code_deploy
		elif [ "$name" == goods ];then
			code_deploy
		elif [ "$name" == code ];then
			code_deploy
		elif [ "$name" == order ];then
			code_deploy
		elif [ "$name" == log ];then
			code_deploy
		elif [ "$name" == statistics ];then
			code_deploy
		elif [ "$name" == scheduled ];then
			code_deploy
		elif [ "$name" == message ];then
			code_deploy
		elif [ "$name" == basefile/manager ];then
			code_deploy
		elif [ "$name" == basefile/public ];then
			code_deploy
		else
			echo no package update
		fi
	done
fi
