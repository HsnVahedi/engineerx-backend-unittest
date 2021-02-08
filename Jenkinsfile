pipeline {
    agent {
        docker {
            image 'hsndocker/cluster-control:latest'
            args '-u root:root'
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