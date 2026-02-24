pipeline {
    agent any

    environment {
        ANSIBLE_HOST_KEY_CHECKING = 'False'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build App') {
            steps {
                dir('app') {
                    sh 'mvn clean package'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh '''
                    terraform init -input=false
                    terraform validate
                    terraform apply -auto-approve
                    terraform output -raw k8s_ip > ../k8s_ip.txt
                    '''
                }
            }
        }

        stage('Configure Kubernetes') {
            steps {
                sh '''
                IP=$(cat k8s_ip.txt)
                ansible-playbook ansible/k8s-setup.yml \
                -i ${IP}, \
                --ssh-common-args='-o StrictHostKeyChecking=no'
                '''
            }
        }

        stage('Fetch Kubeconfig') {
            steps {
                sh '''
                IP=$(cat k8s_ip.txt)
                mkdir -p ~/.kube
                scp -o StrictHostKeyChecking=no ubuntu@$IP:/home/ubuntu/.kube/config ~/.kube/config
                '''
            }
        }

        stage('Deploy App') {
            steps {
                dir('helm') {
                    sh '''
                    helm upgrade --install alex-app alex-app
                    '''
                }
            }
        }

    }

    post {
        success {
            echo "✅ PIPELINE SUCCESSFUL – APP DEPLOYED"
        }
        failure {
            echo "❌ PIPELINE FAILED – CHECK LOGS"
        }
        always {
            cleanWs()
        }
    }
}
