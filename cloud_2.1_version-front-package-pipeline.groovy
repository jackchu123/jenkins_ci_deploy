// cloud_2.1_version-front-package-pipeline_v1.0
// v1.0 2020/4/29 初步设计，说明如下
// 2020/4/29 Cloud_2.1 版本设计，说明如下
// Cloud_2.1 版本前端版本组件打包，SVN组件上传
// 1. 测试环境为192.168.1.115，实际环境192.168.1.131
// 2. 组件代码是qccvas-fronted项目代码test分支,jenkins容器在192.168.2.25
// 3. 远程后台执行1.48 jie/xindeqd D:\git_cloud2.1\front_bat 目录bat脚本，并将指定压缩包传回对应节点并上传到svn
pipeline {
	agent any
	parameters {
		extendedChoice(description: '打包前端服务组件(注：远程Windows系统执行)', name: 'jenkins_build_front', value:'server115_web-app,server115_web-cloud-ent,server115_web-cloud-mgr,server115_web-download,server131_web-app,server131_web-cloud-ent,server131_web-cloud-mgr,server131_web-download', type: 'PT_CHECKBOX', visibleItemCount: 8)
		choice(description: '当前服务版本', name: 'cloud_version', choices: 'v2.1.3.6\nv2.1.3.5\nv2.1.3.4' )
		choice(description: '执行服务器', name: 'server_name', choices: 'server115\nserver131' )
	}
	stages {
		stage('zip front'){
			steps {
				echo "前端组件打包"
				sh """
					ssh root@${server_name} "cp /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_build_front.bak /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_build_front.sh"
					ssh root@${server_name} "sed -i s#cloud_version#${cloud_version}#g /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_build_front.sh"
					ssh root@${server_name} "sed -i s#jenkins_build_front#${jenkins_build_front}#g /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_build_front.sh"
					ssh root@${server_name} "/home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_build_front.sh"
				"""
			}
		}
	}
}