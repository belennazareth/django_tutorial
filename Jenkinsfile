pipeline {
    agent none
    stages {
        stage('Clone') {
            agent {
                docker { image 'python:3'
                args '-u root:root'
                }
            }
            steps {
                git branch:'master',url:'https://github.com/belennazareth/django_tutorial.git'
            }
        }
        stage('Install') {
            agent {
                docker { image 'python:3'
                args '-u root:root'
                }
            }
            steps {
                sh 'pip install -r requirements.txt'
            }
        }
        stage('Test') {
            agent {
                docker { image 'python:3'
                args '-u root:root'
                }
            }
            steps {
                sh 'python3 manage.py test'
            }
        }
        stage('Build') {
            agent any
            steps {
                script {
                    def dockerImage = docker.build("belennazareth/django_tutorial:${env.BUILD_ID}")
                }
            }
        }
        stage('Push image') {
            agent any
            steps {
                script {
                    withDockerRegistry([ credentialsId: "DOCKER_HUB", url: "" ]) {
                        dockerImage.push()
                    }
                }
            }
        }
        stage('Remove image') {
            agent any
            steps {
                script {
                    sh 'docker rmi belennazareth/django_tutorial:${env.BUILD_ID}'
                }
            }
        }
    }
}
