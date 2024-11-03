# To-Do Application Documentation

This is a basic To-Do application that provides CRUD (Create, Read, Update, Delete) functionality.

## Local Deployment

### Prerequisites

- Docker Engine installed on your machine
- Docker Compose installed on your machine
- Git (for cloning the repository)

### Environment Setup

1. Create a `.env` file in the root directory with the following variables:

```
DB_PASSWORD=YOURPASSWORD    # MySQL database password
DB_NAME=YOURDBNAME         # Name of the database to be created
DB_USER=DBUSER            # Database user (typically 'root' for local development)
DB_HOST=DBHOST            # Use 'mysql' for local deployment
```

### Deployment Steps

1. **Build the Docker Image**

   ```bash
   # Navigate to the project directory containing the Dockerfile
   docker build -t todo_app .
   ```

2. **Start the Application**

   ```bash
   # Start both containers (MySQL and Todo App)
   docker compose up -d
   ```

3. **Verify Deployment**
   - The application will be available at `http://localhost:8080`
   - MySQL database will be accessible on port 3306

### Container Information

- **Todo App Container**

  - Container name: `todo_app`
  - Port: 8080
  - Depends on MySQL container being healthy

- **MySQL Container**
  - Container name: `mysql_db`
  - Port: 3306
  - Includes health check configuration
  - Persistent volume for data storage

### Stopping the Application

```bash
# Stop and remove containers
docker compose down
```

### Troubleshooting

- Ensure all environment variables in `.env` file are correctly set
- Check container logs using `docker logs todo_app` or `docker logs mysql_db`
- Verify MySQL container health status using `docker ps`
- Ensure ports 8080 and 3306 are not in use by other applications

## AWS Deployment Guide

### Prerequisites

- AWS CLI installed and configured
- Terraform installed
- Git (for cloning the repository)
- Docker installed locally

### Initial Setup

#### 1. AWS IAM Configuration

1. Create a new IAM user group with the following policies:

   - EC2InstanceProfileForImageBuilderECRContainerBuilds
   - AmazonS3FullAccess
   - AmazonRDSFullAccess
   - AmazonECS_FullAccess
   - AmazonEC2FullAccess
   - AmazonEC2ContainerRegistryFullAccess

2. Create a new IAM user and add it to the group
3. Generate Access Key and Secret Access Key for the user
4. Configure AWS CLI:
   ```bash
   aws configure
   ```
   - Enter your Access Key and Secret Key
   - Default region: ap-south-1 (or your preferred region)
   - Default output format: json

#### 2. Environment Configuration

Create a `terraform.tfvars` file in the terraform directory:

```hcl
db_name     = "your_database_name"
db_password = "your_secure_password"
db_username = "your_database_username"
```

### Deployment Process

#### 1. Setting up ECR Repository

```bash
# Navigate to ECR repository Terraform directory
cd terraform/ecr-repo

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the configuration
terraform apply
```

To get your ECR repository URL:

```bash
aws ecr describe-repositories --repository-names <repository-name> \
    --query 'repositories[0].repositoryUri' --output text
```

#### 2. Building and Pushing Docker Image

```bash
# Authenticate Docker to ECR
aws ecr get-login-password --region ap-south-1 | \
    docker login --username AWS --password-stdin <your-repo-url>

# Build the image
docker build -t todo-app .

# Tag the image
docker tag todo-app:latest <your-repo-url>:latest

# Push to ECR
docker push <your-repo-url>:latest
```

#### 3. Deploying the Infrastructure

```bash
# Navigate to main Terraform directory
cd terraform

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the configuration
terraform apply
```

### CI/CD Workflows

The repository contains three main GitHub Actions workflows:

1. **build-image.yml**

   - Builds Docker image from Dockerfile
   - Triggered on specific events
   - Ensures consistent image building

2. **ecr-repo-setup.yml**

   - Creates private ECR repository
   - Triggers build-image workflow
   - Triggered on push to master branch

3. **deploy-aws-infra.yml**
   - Provisions AWS infrastructure:
     - RDS instance
     - ECS Cluster
     - Application Load Balancer
     - Auto Scaling Group
     - EC2 instances
   - Triggered after successful image build

### Accessing the Application

Once deployed, you can access the application using the ALB DNS name. To get the ALB DNS:

```bash
aws elbv2 describe-load-balancers \
    --query 'LoadBalancers[0].DNSName' \
    --output text
```

## Cleanup

To destroy the infrastructure:

```bash
# In terraform directory
terraform destroy

# In ecr-repo directory
cd terraform/ecr-repo
terraform destroy
```

### Region Configuration

The default region is set to ap-south-1. To use a different region:

1. Update region in all `main.tf` files
2. Update region in AWS CLI configuration
3. Update any region-specific resources in Terraform configs
