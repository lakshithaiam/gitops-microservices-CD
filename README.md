# 11-Tier Microservices Application - Online Boutique (GitOps)

This project demonstrates a GitOps-enabled DevOps pipeline for deploying an 11-tier microservices e-commerce application based on Google’s Online Boutique demo. Using GitOps principles, ArgoCD automates continuous deployment, synchronizing the application’s Git repository state with the live Kubernetes environment. The CI/CD workflow is managed across two repositories: one for continuous integration (CI) and another for continuous deployment (CD).

[CI REPOSITORIE:](https://github.com/GoogleCloudPlatform/microservices-demo)

## Acknowledgements

The microservices source code is adapted from the [Online Boutique microservices-demo](https://github.com/GoogleCloudPlatform/microservices-demo), licensed under the Apache 2.0 License.

---

## Microservice Architecture

![Architecture Diagram](https://github.com/lakshithaiam/gitops-microservices-CD/blob/main/Architecture_Diagram_gitops.jpg)

## GitOps CI/CD Pipeline

The CI/CD pipeline is split between two Git repositories:

1. **CI Repository**: Contains source code, Dockerfiles, and Jenkins pipeline configurations for building and pushing Docker images.
2. **CD Repository**: Hosts Kubernetes manifests and Helm charts, which ArgoCD monitors for changes to trigger deployments in the Kubernetes cluster.

The pipeline automates the full lifecycle of building, deploying, and monitoring microservices using:

- **Git** for version control and configuration management
- **Jenkins** for continuous integration and Docker image creation
- **Docker** for containerizing each microservice
- **Kubernetes** for application orchestration
- **Terraform** for AWS infrastructure provisioning
- **ArgoCD** for GitOps-driven continuous deployment to Kubernetes
- **Helm** for deploying the monitoring stack
- **Prometheus and Grafana** for system monitoring and visualization

---

## Detailed Workflow

### CI Workflow (Code Commit and Docker Image Build)

1. **Code Commit to CI Repository**  
   - **Developer Action**: Developers push code changes to individual branches for each microservice in the CI repository.
   - **Branches**: Each microservice has its own branch containing a `Jenkinsfile` for CI pipeline configurations.

2. **GitHub Webhook Triggers Jenkins**  
   - **Trigger**: GitHub sends a webhook notification to Jenkins upon code push.
   - **Jenkins**: Detects changes in each branch and initiates the build process for the affected microservice.

3. **Build Docker Images**  
   - Jenkins uses Docker to build images for each microservice, tagging each image with the new version, and pushes them to Docker Hub.

4. **Tagging and Versioning**  
   - Each successful CI build results in a version tag, which is subsequently referenced in the CD pipeline to ensure accurate version deployment.

### CD Workflow (Infrastructure, Kubernetes Manifest and Helm Chart Deployment)

5. **Update Kubernetes Manifests in CD Repository**  
   - The new version tag is updated in the `k8-manifest.yml` file in the CD repository, referencing the latest Docker image version.
   - This change is committed to the CD repository, triggering ArgoCD to synchronize the Kubernetes cluster state with the updated manifest.

6. **Provisioning with Terraform**  
   - Terraform is used to provision the necessary AWS infrastructure: EC2 instances, VPCs, security groups, and the EKS cluster.
   - Terraform ensures that the infrastructure is scalable and secure, utilizing auto-scaling groups for EC2 instances and network security groups for fine-tuned access control.

7. **ArgoCD Deployment to Kubernetes**  
   - **ArgoCD**: ArgoCD watches the CD repository for changes. Upon detecting a new version tag in `k8-manifest.yml`, ArgoCD initiates a deployment to Kubernetes with the latest Docker image.
   - **Namespace**: Microservices are deployed in a designated namespace within the EKS cluster for organized resource management.

7. **Deploying the Monitoring Stack with Helm**  
   - **Helm Chart**: Prometheus and Grafana are deployed using a Helm chart.

8. **Load Balancing and Scaling**  
   - **Microservices Load Balancer**: Distributes incoming traffic across frontend replicas, ensuring resilience and availability for the application's main interface.
   - **ArgoCD Load Balancer**: Provides external access to ArgoCD for managing and synchronizing application deployments.
   - **Grafana Load Balancer**: Allows secure, external access to Grafana dashboards for monitoring microservices and infrastructure performance.
    - **Auto-scaling**: Kubernetes dynamically adjusts the number of pod replicas based on load, maintaining optimal performance during high-traffic periods.

### Application Monitoring

10. **Prometheus and Grafana**  
   - Deployed via Helm, **Prometheus** collects metrics while **Grafana** provides real-time visualizations. Dashboards offer insights into resource usage, microservice health, and performance metrics across the application.

---

## Contributing

Contributions are welcome! Please open an issue or submit a pull request to suggest improvements.

## License

This project is licensed under the MIT License. For more details, see the [LICENSE](LICENSE) file.

---
