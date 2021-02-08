pipeline {
    agent {
        docker {
            image 'hsndocker/cluster-control:latest'
            args '-u root:root -v /home/hossein/.kube:/root/.kube:ro -v /home/hossein/.minikube:/root/.minikube:ro'
        }
    }
    stages {
        stage('Deploy Unittest') {
            steps {
                sh 'cd /root/kubectl && ./kubectl version'
            }
        } 
    }
}