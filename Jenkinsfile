pipeline {
    agent {
        docker {
            image 'hsndocker/cluster-control:latest'
            args '-u root:root -v /home/hossein/.kube:/root/.kubecopy:ro -v /home/hossein/.minikube:/root/.minikube:ro'
        }
    }
    stages {
        stage('Configure kubectl and terraform') {
            steps {
                echo '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
                sh 'ls -a'
                echo '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
                sh 'cd /root && cp -r .kubecopy .kube'
                sh 'cd /root/.kube && rm config && mv minikube.config config'
                sh 'cp /root/terraform/terraform .'
            }
        } 
        stage('Deploy Backend Unittest') {
            steps {
                sh './terraform init'
            }
        }
    }
}