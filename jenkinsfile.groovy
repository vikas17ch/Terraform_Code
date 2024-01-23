pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    withAWS(region: 'us-east-2', credentials: 'my-aws-credentials') {
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }
    }
}
