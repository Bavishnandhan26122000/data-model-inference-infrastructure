# Data Model Inference Infrastructure

This repository contains the infrastructure and application code to deploy a robust, scalable data model inference service. It bridges the gap between data science and operations by provisioning specialized compute resources (e.g., GPU instances) and deploying a containerized inference API.

## Architecture

*   **Infrastructure (Terraform):** Provisions an AWS Virtual Private Cloud (VPC), Subnets, Security Groups, and a GPU-optimized EC2 instance (`g4dn.xlarge` by default) running an AWS Deep Learning AMI.
*   **Application (Python/FastAPI):** A high-performance REST API to serve model predictions.
*   **Containerization (Docker):** Packages the application and its dependencies into an isolated container for consistent deployment across environments.

## Repository Structure

```
.
├── app/
│   ├── main.py             # FastAPI application
│   └── requirements.txt    # Python dependencies
├── terraform/
│   ├── main.tf             # Core infrastructure resources
│   ├── variables.tf        # Input variables
│   └── outputs.tf          # Output values (IPs, Endpoints)
├── Dockerfile              # Container definition
└── README.md
```

## Getting Started

### 1. Provision Infrastructure

Ensure you have [Terraform](https://developer.hashicorp.com/terraform/downloads) and the [AWS CLI](https://aws.amazon.com/cli/) installed and configured.

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

Note the `api_endpoint` output after a successful apply.

### 2. Deploy the Application

Once the EC2 instance is running, you can connect to it and run the Docker container. 
*(In a production setup, this step would be handled by a CI/CD pipeline and an orchestrator like ECS or EKS).*

```bash
# Build the Docker image
docker build -t inference-api .

# Run the container
docker run -d -p 8000:8000 inference-api
```

### 3. Test the Inference Endpoint

Send a request to the API:

```bash
curl -X POST "http://<EC2_PUBLIC_IP>:8000/predict" \
     -H "Content-Type: application/json" \
     -d '{"data": [1.2, 3.4, 5.6], "model_version": "v1"}'
```
