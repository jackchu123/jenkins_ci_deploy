// cloud_2.1_version-backgroud-pipeline_v1.0
// v1.0 2020/4/24 初步设计，说明如下
// 2020/4/24 Cloud_2.1 版本设计，说明如下
// Cloud_2.1 版本后端版本组件更新，SVN组件上传
// 1. 测试环境为192.168.1.115，实际环境192.168.1.113
// 2. 组件代码是qccvas-backend项目代码test分支,jenkins容器在192.168.2.25
// 3，版本更新首先更新数据库，131环境中,basic库是企业库，env是环境库，manager是管理库。组件更新需要先执行manager并停滞1min等待数据，再来重置其它服务
// 4. 前端代码有兼容性问题，所以现阶段需要将前端人员打好的包放入指定目录进行脚本执行。小应用与马良项目暂时不执行
pipeline {
	agent any
	parameters {
		extendedChoice(description: '更新数据库文件', name: 'jenkins_mysql_file', value:'manager.sql,tenant.sql,environment.sql', type: 'PT_CHECKBOX', visibleItemCount: 2)
		extendedChoice(description: '更新后端服务组件(注：manager服务需要首先执行,且需要按照服务器对应目录名填写)', name: 'jenkins_background_file', value:'qccvas-biz-manager,qccvas-biz-statistics,qccvas-biz-user,qccvas-biz-code,file-manager-starter,qccvas-base-log,file-public-starter,qccvas-base-message,qccvas-base-tenant,qccvas-biz-base,qccvas-biz-goods,qccvas-biz-order,qccvas-base-scheduled', type: 'PT_CHECKBOX', visibleItemCount: 13)
		extendedChoice(description: '更新前端服务组件(注：由windows打包，传输到131/115指定目录上传SVN)', name: 'jenkins_front_file', value:'web-cloud-ent,web-cloud-mgr', type: 'PT_CHECKBOX', visibleItemCount: 2)
		choice(description: '当前服务版本', name: 'cloud_version', choices: 'v2.1.3.3\nv2.1.3.2\nv2.1.3.1' )
		choice(description: '执行服务器', name: 'server_name', choices: 'server115\nserver131' )
		choice(description: '代码分支', name: 'git_name', choices: 'test\nhotfix' )
	}

	stages {
		stage('Updata Mysql Database'){
			steps {
				echo "更新数据库"
				sh """
					ssh root@${server_name} "cp /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_sql.bak /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_sql.sh"
					ssh root@${server_name} "sed -i s#cloud_version#${cloud_version}#g /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_sql.sh"
					ssh root@${server_name} "sed -i s#jenkins_mysql_file#${jenkins_mysql_file}#g /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_sql.sh"
					ssh root@${server_name} "/home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_sql.sh"
				"""
			}
		}
		stage('Updata Git'){
			steps {
				echo "更新Git"
					sh """
						ssh root@${server_name} "cp /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_git.bak /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_git.sh"
						ssh root@${server_name} "sed -i s#git_name#${git_name}#g /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_git.sh"
						ssh root@${server_name} "/home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_git.sh"
					"""
			}
		}
		stage('Updata background'){
			steps {
				echo "更新后端服务组件"
				sh """
					ssh root@${server_name} "cp /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_back.bak /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_back.sh"
					ssh root@${server_name} "sed -i s#jenkins_background_file#${jenkins_background_file}#g /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_back.sh"
					ssh root@${server_name} "/home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_back.sh"
				"""
			}
		}
		stage('SVN upload'){
			steps {
				echo "上传SVN"
				sh """
					ssh root@${server_name} "cp /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_svn_upload.bak /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_svn_upload.sh"
					ssh root@${server_name} "sed -i s#cloud_version#${cloud_version}#g /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_svn_upload.sh"
					ssh root@${server_name} "/home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_svn_upload.sh"				
				"""
			}
		}
		stage('Updata frontend'){
			steps {
				echo "更新前端服务组件"
				sh """
					ssh root@${server_name} "cp /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_front_ci.bak /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_front_ci.sh"
					ssh root@${server_name} "sed -i s#cloud_version#${cloud_version}#g /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_front_ci.sh"
					ssh root@${server_name} "sed -i s#jenkins_front_file#${jenkins_front_file}#g /home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_front_ci.sh"
					ssh root@${server_name} "/home/sanyuanse/cloud2_1_0/sh/cloud_2.1_version/cloud_2.1_version_front_ci.sh"
				"""
			}
		}
	}
}

