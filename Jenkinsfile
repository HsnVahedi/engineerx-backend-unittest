pipeline {
    agent {
        docker {
            image 'hsndocker/cluster-control:latest'
            args '-u root:root -v /home/hossein/.kube:/root/.kubecopy:ro -v /home/hossein/.minikube:/root/.minikube:ro'
        }
    }
    
    parameters {
        string(name: 'BACKEND_VERSION', defaultValue: 'latest')
    }
    environment {
        DOCKERHUB_CRED = credentials('dockerhub-repo')
        BACKEND_VERSION = "${params.BACKEND_VERSION}"
        BUILD_ID = "${env.BUILD_ID}"
    }
    stages {
        stage('Configure kubectl and terraform') {
            
            steps {
                sh 'cd /root && cp -r .kubecopy .kube'
                sh 'cd /root/.kube && rm config && mv minikube.config config'
                sh 'cp /root/terraform/terraform .'
                sh 'cp /root/kubectl/kubectl .'
            }
        } 
        stage('Deploy Backend Unittest') {
            steps {
                sh './terraform init'
                sh('./terraform apply -var test_number=$BUILD_ID -var backend_version=$BACKEND_VERSION -var dockerhub_username=$DOCKERHUB_CRED_USR -var dockerhub_password=$DOCKERHUB_CRED_PSW --auto-approve')
                sh "./kubectl wait --for=condition=ready --timeout=600s -n backend-unittest pod/unittest-${env.BUILD_ID}" 
		        sh "./kubectl exec -n backend-unittest unittest-${env.BUILD_ID} -c backend -- bash unittests.sh"
            }
            post {
                always {
                    sh "./terraform destroy -var test_number=${env.BUILD_ID} -var backend_version=${params.BACKEND_VERSION} --auto-approve"
                }
            }
        }
        
        stage('Invoke Setting latest tags') {
            steps {
                build job: 'engineerx-backend-latest-tag', parameters: [
                    string(name: "BACKEND_VERSION", value: "${params.BACKEND_VERSION}")
                ]
            }
        }
    }
}
