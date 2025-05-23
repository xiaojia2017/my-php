pipeline {
    agent any

    environment {
        // 定义环境变量
        GIT_REPO = 'git@github.com:xiaojia2017/my-php.git' 
        DEPLOY_DIR = '/my-php' 
        SSH_USER = 'jenkins'
        SSH_HOST = 'tcp://dind:2375' 
    }

    stages {
        stage('Checkout') {
            steps {
                // 拉取代码
                git branch: 'main', url: "${env.GIT_REPO}", credentialsId: 'github'
            }
        }

        stage('Build Docker Image') {
            steps {
                // 构建 Docker 镜像
                script {
                    docker.build("my-php-app:latest")
                }
            }
        }
		
        stage('Debug Path') {
            steps {
              sh 'pwd' // 查看当前工作目录的绝对路径
              sh 'ls -la' // 查看当前目录下的文件结构
			  sh """
            #!/bin/bash
            echo "DEPLOY_DIR: ${env.DEPLOY_DIR}"
        """
            }
        }

        stage('Deploy to Server') {
            steps {
                // 使用 SSH 将文件同步到目标服务器 
                sshPublisher(
                    publishers: [
                        sshPublisherDesc(
                            configName: 'jenkins',
                            transfers: [
                                sshTransfer(
                                    sourceFiles: '**/*',
                                    remoteDirectory: "${env.DEPLOY_DIR}",
                                    removePrefix: '',
                                    execCommand: '''
									    echo "DEPLOY_DIR: ${env.DEPLOY_DIR}" && 
                                        ls -la ${env.DEPLOY_DIR} &&
                                        cd ${env.DEPLOY_DIR} &&
                                        docker-compose down &&
                                        docker-compose up -d
                                    '''
                                )
                            ]
                        )
                    ]
                )
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}