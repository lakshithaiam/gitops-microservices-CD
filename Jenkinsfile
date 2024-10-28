pipeline {
    agent any

    stages {
        stage('Initialize Terraform') {
            steps {
                script {
                    dir('terraform') {
                        sh "terraform --version"
                        sh "terraform init"
                    }
                }
            }
        }
        stage('Plan Infrastructure Changes') {
            steps {
                script {
                    dir('terraform') {
                        sh "terraform plan"
                    }
                    input(message: "Are you sure you want to proceed with applying the infrastructure changes?", ok: "Proceed")
                }
            }
        }
        stage('Manage Infrastructure State') {
            steps {
                script {
                    dir('terraform') {
                        def action = input message: 'Select Action', parameters: [
                            choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Choose whether to apply or destroy the infrastructure')
                        ]

                        if (action == 'apply') {
                            sh 'terraform apply --auto-approve'
                        } else if (action == 'destroy') {
                            sh 'terraform destroy --auto-approve'
                        }
                    }
                }
            }
        }
        stage('Deploy Ecommerce Web Application') {
            steps {
                script {
                    dir('configuration') {
                        sh 'aws eks update-kubeconfig --name myapp-eks-cluster'
                        sh 'kubectl create namespace argocd'
                        sh 'kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml'
                        sh 'kubectl get all -n argocd'
                        sh 'kubectl patch svc argocd-server -n argocd -p "{\\"spec\\": {\\"type\\": \\"LoadBalancer\\"}}"'
                    }
                }
            }
        }
        stage('Install Prometheus and Grafana') {
            steps {
                script {
                    dir('configuration') {
                        // Update kubeconfig for EKS
                        sh 'aws eks update-kubeconfig --name myapp-eks-cluster'
                        
                        // Add Helm repos and install monitoring stack
                        sh 'helm repo add stable https://charts.helm.sh/stable'
                        sh 'helm repo add prometheus-community https://prometheus-community.github.io/helm-charts'
                        sh 'helm search repo prometheus-community'
                        sh 'kubectl create namespace prometheus || true' // Ignore error if namespace already exists
                        sh 'helm install stable prometheus-community/kube-prometheus-stack -n prometheus'
                        sh 'kubectl patch svc stable-grafana -n prometheus -p "{\\"spec\\": {\\"type\\": \\"LoadBalancer\\"}}"'
                        sh 'kubectl get pods -n prometheus'
                        sh 'kubectl get svc -n prometheus'
                    }
                }
            }
        }
    }
}
