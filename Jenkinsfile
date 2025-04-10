pipeline {
    agent any

    environment {
        // 定义环境变量
        GIT_REPO = 'https://github.com/xiaojia2017/my-php.git'
        DEPLOY_DIR = '/home/jenkins/my-php'
        SSH_USER = 'jenkins'
        SSH_HOST = '47.106.192.129'
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
                                        cd /home/jenkins/my-php &&
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