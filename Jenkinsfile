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
    stages {
        stage('Test') {
            steps {
                sh 'docker login'
            }
            
        }
        // stage('Configure kubectl and terraform') {
        //     steps {
        //         sh 'cd /root && cp -r .kubecopy .kube'
        //         sh 'cd /root/.kube && rm config && mv minikube.config config'
        //         sh 'cp /root/terraform/terraform .'
        //         sh 'cp /root/kubectl/kubectl .'
        //     }
        // } 
        // stage('Deploy Backend Unittest') {
        //     steps {
        //         sh './terraform init'
        //         sh "./terraform apply -var test_number=${env.BUILD_ID} -var backend_version=${params.BACKEND_VERSION} --auto-approve"
        //         sh "./kubectl wait --for=condition=ready --timeout=600s -n unittest pod/unittest-${env.BUILD_ID}" 
		//         sh "./kubectl exec unittest-${env.BUILD_ID} -c backend -- ./unittest.sh"
        //     }
        //     post {
        //         always {
        //             sh "./terraform destroy -var test_number=${env.BUILD_ID} -var backend_version=${params.BACKEND_VERSION} --auto-approve"
        //         }
        //     }
        // }
        // stage('Invoke Deployment to Production') {
        //     steps {
        //         build job: 'engineerx-deployment', parameters: [
        //             string(name: "BACKEND_VERSION", value: "${params.BACKEND_VERSION}")
        //         ]
        //     }
        // }
    }
}
