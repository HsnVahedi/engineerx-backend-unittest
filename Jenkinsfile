pipeline {
    agent {
        docker {
            image 'hsndocker/aws-cli:latest'
            args '-u root:root'
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
        stage('Providing Access Keys') {
            steps {
                sh('aws configure set aws_access_key_id $ACCESS_KEY_ID')
                sh('aws configure set aws_secret_access_key $SECRET_KEY')
                sh('aws configure set default.region $REGION')
            }
        }
        stage('Setting kubeconfig') {
            steps {
                sh('aws eks --region $REGION update-kubeconfig --name $CLUSTER_NAME')
            }
        }
        stage('Deploy Backend Unittest') {
            steps {
                sh 'terraform init'
                sh('terraform apply -var test_number=$BUILD_ID -var backend_version=$BACKEND_VERSION -var dockerhub_username=$DOCKERHUB_CRED_USR -var dockerhub_password=$DOCKERHUB_CRED_PSW --auto-approve')
                sh "kubectl wait --for=condition=ready --timeout=600s -n backend-unittest pod/unittest-${env.BUILD_ID}" 
		        sh "kubectl exec -n backend-unittest unittest-${env.BUILD_ID} -c backend -- python manage.py test authentication"
                sh "kubectl exec -n backend-unittest unittest-${env.BUILD_ID} -c backend -- python manage.py test home"
            }
            post {
                always {
                    sh('terraform destroy -var test_number=$BUILD_ID -var backend_version=$BACKEND_VERSION -var dockerhub_username=$DOCKERHUB_CRED_USR -var dockerhub_password=$DOCKERHUB_CRED_PSW --auto-approve')
                }
            }
        }
    }
}
