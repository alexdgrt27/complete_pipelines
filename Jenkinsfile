pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    environment {
        GIT_REPO = 'https://github.com/alexdgrt27/complete_pipelines.git'
        GIT_BRANCH = 'main'
        TF_IN_AUTOMATION = 'true'
    }

    stages {

        /* =======================
           SCM CHECKOUT
        ======================== */
        stage('Checkout SCM') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: "*/${GIT_BRANCH}"]],
                    userRemoteConfigs: [[
                        url: "${GIT_REPO}",
                        credentialsId: 'git_hub_token_001'
                    ]]
                ])
            }
        }

        /* =======================
           BUILD APPLICATION
        ======================== */
        stage('Build App') {
            steps {
                dir('app') {
                    sh '''
                      mvn -version
                      mvn clean package
                    '''
                }
            }
        }

        /* =======================
           TERRAFORM APPLY
        ======================== */
        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh '''
                      terraform --version
                      terraform init -input=false
                      terraform validate
                      terraform apply -auto-approve
                      terraform output -raw k8s_ip > ../k8s_ip.txt
                    '''
                }
            }
        }

        /* =======================
           KUBERNETES CONFIG
        ======================== */
        stage('Configure Kubernetes') {
    steps {
        sh '''
        export ANSIBLE_HOST_KEY_CHECKING=False
        ansible-playbook ansible/k8s-setup.yml -i $(cat k8s_ip.txt),
        '''
    }
 }

        /* =======================
           APPLICATION DEPLOY
        ======================== */
        stage('Deploy App') {
            steps {
                sh '''
                  helm version
                  helm upgrade --install webapp helm/webapp \
                  --create-namespace \
                  --namespace webapp
                '''
            }
        }

        /* =======================
           MONITORING STACK
        ======================== */
        stage('Install Monitoring') {
            steps {
                sh '''
                  helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
                  helm repo add grafana https://grafana.github.io/helm-charts
                  helm repo update

                  helm upgrade --install prometheus prometheus-community/prometheus \
                  --namespace monitoring --create-namespace \
                  -f helm/monitoring/prometheus-values.yaml

                  helm upgrade --install grafana grafana/grafana \
                  --namespace monitoring \
                  -f helm/monitoring/grafana-values.yaml

                  helm upgrade --install loki grafana/loki \
                  --namespace monitoring \
                  -f helm/monitoring/loki-values.yaml
                '''
            }
        }
    }

    post {
        success {
            echo '✅ PIPELINE COMPLETED SUCCESSFULLY'
        }
        failure {
            echo '❌ PIPELINE FAILED – CHECK STAGE LOGS'
        }
        always {
            cleanWs()
        }
    }
}
