// cloud_2.1_version-release-pipeline_v1.0
// v1.0 2020/05/07 初步设计，说明如下
// 2020/05/07 Cloud_2.1 版本设计，说明如下
// Cloud_2.1 版本备份输出起始到最终版所有数据
// 1. 测试环境为192.168.1.115，实际环境192.168.1.131
// 2. 组件代码是qccvas-fronted项目代码test分支,jenkins容器在192.168.2.25
// 3. SVN版本中，test分支限定2.1.3版本
// 4. 如版本迭代，需要修改脚本默认配置
pipeline {
	agent any
	parameters {
		string(defaultValue: '', description: '起始svn版本', name: 'start_cloud_version')
		string(defaultValue: '', description: '结束svn版本', name: 'end_cloud_version')
		choice(name: 'GIT_CHOICES', choices: 'test\nhotfix', description: '代码分支')
	}
	stages {
		stage('svn download'){
			steps{
				echo "上传上线版本数据"
				script{
					sh """
						ssh root@server131 "cp /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_release.bak /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_release.sh"
						ssh root@server131 "sed -i s#start_cloud_version#${start_cloud_version}#g /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_release.sh"
						ssh root@server131 "sed -i s#end_svn_version#${end_cloud_version}#g /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_release.sh"
						ssh root@server131 "sed -i s#git_choices#${GIT_CHOICES}#g /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_release.sh"
						ssh root@server131 "/home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_release.sh"
					"""
				}
			}
		}
	}
}