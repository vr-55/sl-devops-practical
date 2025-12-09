# SL DevOps Assignment: GCP Kubernetes Cluster

## Tools you need to complete the assignment
*   **GCP** (Google Cloud Platform)
*   **Terraform** (Infrastructure as Code)
*   **Helm** (Package Manager for Kubernetes)
*   **Kubectl** (Kubernetes CLI)
*   **gcloud** (GCP CLI)
*   **kurl.sh** (Kubernetes Installer)
*   **Docker Desktop** (Containerization)

## Approach chosen to complete the assignment
1.  Used **Kurl.sh** to bootstrap the K8S cluster in GCP.
2.  Used **Terraform** to provision VPC network and VMs in GCP.
3.  Built a **Non-HA cluster** with 1 master and 2 worker nodes.
4.  Used instance metadata in Terraform while provisioning VMs to install NTP and copy SSH public keys.
5.  Used **Service type NodePort** to access the application via the internet.
6.  Used **buildx** to build multi-platform container images.
7.  Used the Docker Desktop engine to build the Node app image and push it to the docker registry.

## Prerequisites to validate the assignment
1.  Sign up into a **GCP account** (make sure you utilize the $300 offer).
2.  Create a project and enable **Network/GCE API**.
3.  Enable billing.
4.  Install **Docker Desktop**, **Kubectl**, **gcloud**, **Helm**, and **Terraform**.

## Deployment steps

1.  **Generate SSH Key**
    ```bash
    ssh-keygen -t ed25519 -C "your_email@example.com"
    ```

2.  **Authenticate GCP Project**
    ```bash
    gcloud auth login
    gcloud auth application-default login
    ```

3.  **Update Terraform Variables**
    *   Replace your public SSH key here: [variables.tf](https://github.com/vr-55/sl-devops-practical/blob/main/terraform-modules/gce/variables.tf#L91)
    *   Replace your GCP project ID, project, and VPC names in both files:
        *   [vpc/terraform.tfvars](https://github.com/vr-55/sl-devops-practical/blob/main/terraform-modules/vpc/terraform.tfvars)
        *   [gce/terraform.tfvars](https://github.com/vr-55/sl-devops-practical/blob/main/terraform-modules/gce/terraform.tfvars)

4.  **Execute Terraform Commands**
    *Provision VPC network, firewall rules, VM, install NTP, and copy SSH pub key to VM.*

    *VPC Module:*
    ```bash
    cd terraform-modules/vpc/
    terraform init
    terraform validate
    terraform plan
    terraform apply -auto-approve
    ```

    *GCE Module:*
    ```bash
    cd ../gce/
    terraform init
    terraform validate
    terraform plan
    terraform apply -auto-approve
    ```

5.  **Bootstrap Master Node**
    Use Kurl.sh to install the control plane.
    ```bash
    curl https://kurl.sh/ad3d71d | sudo bash
    ```

6.  **Join Worker Nodes**
    *   It will take 7-10 minutes to install control plane components.
    *   At the end, it will show the URL to invoke and the command for worker nodes to join the cluster.
    *   Copy the join command and run it in all **worker nodes**.

7.  **Validate Cluster Status**
    Check that all nodes have joined and are in `Ready` status.
    ```bash
    kubectl get nodes
    kubectl get ns
    kubectl get all -n kube-system
    ```

8.  **Configure Local Access**
    *   After the master node is ready, Kurl will display the `kubeconfig`.
    *   Follow the instructions to download it to your local machine (ensure required firewall ports are open).

9.  **Build Docker Image**
    Authenticate with Docker (`docker login`) and build the image.
    ```bash
    docker buildx build --platform linux/amd64 -t abc/sl-sre-practical:latest --push .
    ```

10. **Execute Helm Commands**
    Deploy the stack using Helm.
    ```bash
    helm lint charts/
    helm install sl-stack charts/ --dry-run --debug
    helm template sl-stack charts/ > debug_output.yaml
    helm upgrade --install sl-stack charts/
    ```

11. **Validate Application**
    *   Pick one of the worker node IPs and access: `http://<ip>:31000`.
    *   *Note: Most modern browsers force HSTS (upgrade to HTTPS). You may have a hard time validating this; use Incognito mode or change the unknown port in the values file.*

## Improvements that can be done to this assignment
1.  **Terraform Organization**: Organize the Terraform directory better by having reusable child modules and one main module in the root directory.
2.  **Atlantis**: Use Atlantis in CI/CD for better visibility of Terraform commands.
3.  **Remote State**: Configure Terraform state to remote (S3, DynamoDB, or GCP Bucket).
4.  **Configuration Management**: Separate configuration management and golden image building/hardening using Ansible and Packer.
5.  **Private Cluster**: Launch the K8S cluster in a private network and set up a VPN to access the cluster.
6.  **Ingress Gateway**: Allow inbound access to the K8S cluster with an Ingress Gateway (Kong, Ambassador, Gloo, Traefik). The IGW spins up a Load Balancer (LB), allowing access via LB DNS instead of node IP.
7.  **HPA**: Configure HPA templates for horizontal scaling based on resource utilization (CPU, Memory).
8.  **Automation**: Automate worker nodes joining the master with Ansible.
9.  **High Availability**: Build an HA cluster with 3 master nodes instead of 1.

## Scalability
1.  **Horizontal Pod Autoscaler (HPA)**: Scale applications based on CPU/Memory thresholds.
2.  **Event-Driven Autoscaling (KEDA)**: Scale based on HTTP/API events or message queues.
3.  **Cluster Autoscaling**: Use Cluster Autoscaler or Karpenter.
4.  **Worker Pools**: Use separate worker pools based on business workloads (e.g., CPU/Memory intensive, ML/AI workloads).

## Security
1.  **VPN**: Have a single point of access to your network using VPN.
2.  **RBAC**: Implement RBAC in K8S for granular access.
3.  **Image Scanning**: Implement image scanning after image build with Snyk.
4.  **Network Policies**: Implement network policies for pod-to-pod communication.
5.  **Encryption**: Use Cert Manager or similar tools to encrypt traffic.
6.  **Service Accounts**: Use service accounts to enforce least privilege for pods.
7.  **Secrets Management**: Use HashiCorp Vault for secret management.
8.  **Distroless Images**: Use distroless images to minimize the attack surface of base images.
9.  **Auditing**: Audit the infrastructure quarterly or biannually.
10. **Resource Quotas**: Control hardware resource consumption by applying quotas & limits per namespace.
