# AWS 2-Tier Web Application - Task Management

## Project Overview

This project automates the deployment of a **2-tier AWS web application** for task management using **Terraform Infrastructure as Code (IaC)**. The application is fully containerized and deployed across multiple AWS services to ensure scalability, high availability, and security.

---

## Architecture

### 2-Tier Architecture Components:

```
┌─────────────────────────────────────────────────────────┐
│                    Internet Users                        │
└────────────────────┬────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────┐
│              Cloudflare Edge Network                     │
│    • tasks.vincloudworks.live                           │
│    • DDoS Protection & WAF                              │
│    • Global CDN & Caching                               │
└────────────────────┬────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────┐
│    SSL/TLS Termination & Load Balancing                 │
│    • Cloudflare SSL/TLS (Edge)                          │
│    • AWS ACM Certificate (Origin)                       │
└────────────────────┬────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────┐
│            Application Load Balancer (ALB)              │
│                   (Public Subnet)                        │
└────────────────────┬────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────┐
│         Auto Scaling Group (ASG) - EC2 Instances        │
│    • Web Tier with Docker Containers                    │
│    • Application pulled from Docker Hub                 │
│    • Private Subnets (Multi-AZ)                         │
└────────────────────┬────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────┐
│              RDS Database (Backend)                      │
│    • Database Tier (Data persistence)                   │
│    • Private Subnets (Multi-AZ)                         │
└─────────────────────────────────────────────────────────┘
```

### Key AWS Services Used:

- **VPC**: Virtual Private Cloud with public and private subnets across multiple AZs
- **ALB**: Application Load Balancer for traffic distribution
- **ASG**: Auto Scaling Group for EC2 instance management and horizontal scaling
- **EC2**: Compute instances running Docker containers
- **RDS**: Relational Database Service for data persistence
- **Security Groups**: Network-level access controls
- **Bastion Host**: Secure access to private resources

---

## Project Structure

```
Terraform Folder/
├── environments/
│   ├── _bootstrap/           # Terraform state initialization
│   ├── prod/                 # Production environment configuration
│   │   ├── backend.tf        # Remote state backend
│   │   ├── main.tf           # Main configuration
│   │   ├── variables.tf      # Variable definitions
│   │   ├── output.tf         # Output values
│   │   ├── terraform.tfvars  # Variable values
│   │   └── user_data.tftpl   # EC2 user data script
│   └── secrets/              # Sensitive configuration
├── modules/
│   ├── vpc/                  # VPC and subnet configuration
│   ├── sg/                   # Security groups
│   ├── alb/                  # Application Load Balancer
│   ├── asg/                  # Auto Scaling Group
│   ├── ec2_basion/           # Bastion host for secure access
│   └── rds/                  # RDS database configuration
└── .gitignore               # Git ignore rules
```

---

## Technologies

- **Infrastructure as Code**: Terraform
- **Cloud Provider**: Amazon Web Services (AWS)
- **Containerization**: Docker (images from Docker Hub)
- **Database**: AWS RDS (MySQL/PostgreSQL)
- **Load Balancing**: AWS Application Load Balancer
- **Auto Scaling**: AWS Auto Scaling Group
- **State Management**: Terraform Remote State (S3 + DynamoDB)
- **Edge Network**: Cloudflare CDN & DDoS Protection
- **SSL/TLS**: Cloudflare + AWS Certificate Manager (ACM)
- **DNS**: Cloudflare Authoritative DNS

---

## Domain & Cloudflare Edge Server

### Domain Configuration

- **Primary Domain**: `tasks.vincloudworks.live`
- **Parent Domain**: `vincloudworks.live`
- **DNS Provider**: Cloudflare (Authoritative DNS)
- **Status**: Active and fully managed via Cloudflare

### Edge Server & CDN Architecture

The application is protected by a **multi-layered edge security and performance infrastructure**:

#### Cloudflare Layer (Edge)
- **Global CDN**: Content delivery through Cloudflare's worldwide edge network
- **DDoS Protection**: Automatic mitigation of distributed denial-of-service attacks
- **Web Application Firewall (WAF)**: Advanced threat protection and bot detection
- **SSL/TLS Encryption** (Edge): Full SSL/TLS protection at Cloudflare edge servers
- **Caching**: Intelligent caching of static and dynamic content for improved performance
- **Compression**: Automatic GZIP/Brotli compression for faster content delivery

#### Dual SSL/TLS Protection

The application implements **dual SSL/TLS protection** for enhanced security:

1. **Cloudflare SSL/TLS (Edge to Client)**
   - Issued by Cloudflare
   - Protects traffic from end-user to Cloudflare edge servers
   - Automatic certificate renewal and management
   - Full, Strict, or Flexible SSL mode configuration

2. **AWS ACM SSL/TLS (Origin)**
   - AWS Certificate Manager provides origin certificate
   - Protects traffic from Cloudflare to AWS ALB (origin)
   - Ensures encrypted communication through the entire chain
   - Certificate rotation handled automatically

#### Traffic Flow

```
User Browser
    ↓ (HTTPS via Cloudflare SSL/TLS)
Cloudflare Edge Server (tasks.vincloudworks.live)
    ↓ (HTTPS via AWS ACM)
AWS Application Load Balancer
    ↓
EC2 Instances (Docker Containers)
    ↓
RDS Database
```

### DNS Records

Cloudflare manages the following DNS configuration:

- **A Record**: Points `tasks.vincloudworks.live` to Cloudflare edge servers
- **CNAME**: Aliases for global distribution (if applicable)
- **TXT Records**: SPF, DKIM, DMARC for email authentication
- **MX Records**: Mail server configuration (if email services enabled)

---

## Prerequisites

Before deploying this project, ensure you have:

1. **AWS Account** with appropriate IAM permissions
2. **Terraform** (v1.0+) installed locally
3. **AWS CLI** configured with valid credentials
4. **SSH Key Pair** created in AWS (for bastion access)
5. **Docker Hub credentials** (if using private repositories)
6. **Git** for version control
7. **Cloudflare Account** with domain `vincloudworks.live` configured
8. **AWS Certificate Manager (ACM)** certificate for origin domain
9. **Domain access** to manage DNS records and Cloudflare settings

### Installation Commands:

```bash
# Install Terraform (macOS)
brew install terraform

# Install Terraform (Windows - using Chocolatey)
choco install terraform

# Configure AWS credentials
aws configure

# Verify Terraform installation
terraform --version
```

---

## Deployment Instructions

### 1. Initialize Terraform State (Bootstrap)

```bash
cd environments/_bootstrap
terraform init
terraform apply
```

### 2. Deploy Production Environment

```bash
cd ../prod

# Initialize Terraform
terraform init -backend-config=backendconfig.tfbackend

# Review the plan
terraform plan -var-file=terraform.tfvars

# Apply the configuration
terraform apply -var-file=terraform.tfvars
```

### 3. Retrieve Outputs

After successful deployment, retrieve the ALB endpoint:

```bash
terraform output load_balancer_dns
```

Access your application using the ALB DNS name provided in the outputs.

---

## Environment Variables

Key variables to configure in `terraform.tfvars`:

- **AWS Region**: AWS region for deployment (e.g., `us-east-1`)
- **VPC CIDR**: VPC CIDR block (e.g., `10.0.0.0/16`)
- **Instance Type**: EC2 instance type (e.g., `t3.medium`)
- **Min/Max Capacity**: ASG scaling limits
- **Docker Image**: Docker image URL from Docker Hub
- **Database Configuration**: RDS credentials and configuration

---

## Security Best Practices

✅ **Implemented in this project:**

- **Cloudflare DDoS Protection**: Automatic mitigation of attacks at edge
- **Dual SSL/TLS Protection**: Cloudflare edge + AWS ACM origin certificates
- **Web Application Firewall (WAF)**: Advanced threat detection and blocking
- **Secrets stored** in separate backend configuration
- **Network segmentation** with public/private subnets
- **Security groups** with least-privilege access
- **Bastion host** for secure admin access
- **RDS encryption** at rest
- **Database in private subnets** (no direct internet access)
- **Load balancer** only exposes HTTPS (configurable)
- **Global CDN caching** through Cloudflare edge network
- **Automatic HTTPS redirects** from HTTP to HTTPS

---

## Scaling & High Availability

- **Auto Scaling**: EC2 instances scale based on CPU/memory metrics
- **Multi-AZ Deployment**: Resources distributed across availability zones
- **Load Balancing**: Traffic distributed across multiple instances
- **Database Replication**: RDS Multi-AZ for database failover

---

## Monitoring & Logs

Monitor your deployment through:

- **CloudWatch**: Application and system logs
- **AWS Console**: Real-time resource monitoring
- **ALB Target Groups**: Health check status of EC2 instances
- **RDS Monitoring**: Database performance metrics

---

## Troubleshooting

### Common Issues:

1. **State Lock Issues**
   ```bash
   terraform force-unlock <LOCK_ID>
   ```

2. **EC2 Instances Failing Health Checks**
   - Verify security group rules allow ALB traffic
   - Check user data script execution: `tail -f /var/log/user-data.log`
   - Verify Docker image is accessible from Docker Hub

3. **Database Connection Errors**
   - Confirm RDS security group allows EC2 access
   - Verify credentials in application configuration
   - Check RDS subnet group configuration

4. **Terraform State Corruption**
   ```bash
   terraform state pull > backup.tfstate
   # Review and restore if necessary
   ```

---

## Cleanup

To destroy all infrastructure and avoid unnecessary charges:

```bash
cd environments/prod
terraform destroy -var-file=terraform.tfvars

cd ../_bootstrap
terraform destroy
```

⚠️ **Warning**: This will permanently delete all resources. Ensure backups exist before running.

---

## Contributing

For contributions or improvements:

1. Create a feature branch
2. Test changes in a non-production environment
3. Document changes in this README
4. Submit a pull request with detailed description

---

## Support & Documentation

- **Terraform Documentation**: https://www.terraform.io/docs
- **AWS Documentation**: https://docs.aws.amazon.com
- **Docker Hub**: https://hub.docker.com

---

## License

[Add appropriate license information]

---

**Last Updated**: May 2026  
**Project Status**: Active
