pipeline {
    agent none
    stages {
        stage ('Testing django') { 
            agent { 
                docker { image 'python:3'
                args '-u root:root'
                }
            }
            stages {
                stage('Clone') {
                    steps {
                        git branch:'master',url:'https://github.com/belennazareth/django_tutorial.git'
                    }
                }
                stage('Install') {
                    steps {
                        sh 'pip install -r requirements.txt'
                    }
                }
                stage('Test') {
                    steps {
                        sh 'python3 manage.py test'
                    }
                } 
            }
        }
        stage('Upload img') {
            agent any
            stages {
                stage('Build and push') {
                    steps {
                        script {
                            withDockerRegistry([credentialsId: 'DOCKER_HUB', url: '']) {
                            def dockerImage = docker.build("belennazareth/django_tutorial:${env.BUILD_ID}")
                            dockerImage.push()
                            }
                        }
                    }
                }
                stage('Remove image') {
                    steps {
                        script {
                            sh "docker rmi belennazareth/django_tutorial:${env.BUILD_ID}"
                        }
                    }
                }
            }
        }
        stage('Deploy') {
            agent any
            steps {
                script {
                    String tagRemove = env.BUILD_ID.toInteger() - 1
                    sshagent(credentials: ['SSH_VPS']) {
                        sh "ssh -o StrictHostKeyChecking=no poke@buizel.ottershell.es docker rmi belennazareth/django_tutorial:${tagRemove}"
                        sh "ssh -o StrictHostKeyChecking=no poke@buizel.ottershell.es docker pull belennazareth/django_tutorial:${env.BUILD_ID}"
                        sh "ssh -o StrictHostKeyChecking=no poke@buizel.ottershell.es wget https://raw.githubusercontent.com/belennazareth/django_tutorial/master/docker-compose.yaml -O docker-compose.yaml"
                        sh "ssh -o StrictHostKeyChecking=no poke@buizel.ottershell.es export DJANGO_VERSION=${env.BUILD_ID} && docker-compose up -d --force-recreate"
                    }
                }
            }
        }
    }
    post {
        always {
            mail to: 'nazare@nazareth.jenkins.org',
            subject: "Status of pipeline: ${currentBuild.fullDisplayName}",
            body: "${env.BUILD_URL} has result ${currentBuild.result}"
        }
    }
}