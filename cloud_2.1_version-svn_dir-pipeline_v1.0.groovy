// cloud_2.1_version-svn_dir-pipeline_v1.0
// v1.0 2020/4/30 初步设计，说明如下
// 2020/4/30 Cloud_2.1 版本设计，说明如下
// Cloud_2.1 版本服务器自动化创建SVN目录，并下载数据，做版本更新用
// 1. 测试环境为192.168.1.115，实际环境192.168.1.131
// 2. 组件代码是qccvas-fronted项目代码test分支,jenkins容器在192.168.2.25
// 3. SVN版本中，test分支限定2.1.3版本，hotfix分支限定4.3ST分支
// 4. 如版本迭代，需要修改下载链接地址
pipeline {
	agent any
	parameters {
		string(defaultValue: '', description: 'svn目录版本(注：115为hotfix分支，例Cloud2.1目录2.1.2.6。131为test分支，例QCCVAS目录2.1.3.5)', name: 'cloud_version')
		choice(name: 'GIT_CHOICES', choices: 'hotfix\ntest', description: '代码分支')
		choice(description: '执行服务器', name: 'server_name', choices: 'server115\nserver131' )
	}
	stages {
		stage('svn download'){
			steps{
				echo "下载对应分支SVN数据"
				script{
					if (params.GIT_CHOICES == 'hotfix') {
						sh """
						ssh root@${server_name} "cp /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_svn_dir.bak /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_svn_dir.sh"
						ssh root@${server_name} "sed -i s#cloud_version#hotfix_v${cloud_version}#g /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_svn_dir.sh"
						ssh root@${server_name} "sed -i s#svn_version#${cloud_version}#g /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_svn_dir.sh"
						ssh root@${server_name} "sed -i s#git_choices#${GIT_CHOICES}#g /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_svn_dir.sh"
						ssh root@${server_name} "/home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_svn_dir.sh"
						"""
					} else {
						sh """
						ssh root@${server_name} "cp /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_svn_dir.bak /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_svn_dir.sh"
						ssh root@${server_name} "sed -i s#cloud_version#v${cloud_version}#g /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_svn_dir.sh"
						ssh root@${server_name} "sed -i s#svn_version#${cloud_version}#g /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_svn_dir.sh"
						ssh root@${server_name} "sed -i s#git_choices#${GIT_CHOICES}#g /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_svn_dir.sh"
						ssh root@${server_name} "/home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_svn_dir.sh"
						"""
					}
				}
			}
		}
	}
}
