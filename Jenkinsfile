pipeline {
    agent {
        docker {
            image 'hsndocker/cluster-control:latest'
            args '-u root:root -v /home/hossein/.kube:/root/.kubecopy:ro -v /home/hossein/.minikube:/root/.minikube:ro'
        }
    }
    stages {
        stage('Configure kubernetes config file') {
            steps {
                sh 'cd /root && cp -r .kubecopy .kube'
                sh 'cd /root/.kube && rm config && mv minikube.config config'
            }
        } 
        stage('Deploy Backend Unittest') {
            steps {
                sh 'cp /root/terraform/terraform .'
                sh './terraform init'
            }
        }
    }
}