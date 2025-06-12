# 🚀 Automated Minecraft Server Deployment for Acme Corp

## 🧱 Background

Welcome to your first DevOps assignment at Acme Corp! Your mission: deploy a fully automated Minecraft server using modern infrastructure-as-code tooling. No more manual clicks or cowboy sysadmins—this pipeline does it all.

We use the following tools:

- **Terraform**: Infrastructure provisioning on AWS  
- **Ansible**: EC2 configuration and Docker installation  
- **Docker Compose**: Minecraft container orchestration  
- **GitHub Actions**: Full CI/CD automation on push  

---

## 📋 Requirements

### ✅ Software to Install Locally

- [Terraform](https://developer.hashicorp.com/terraform/downloads) (v1.2+)
- [Ansible](https://docs.ansible.com/)
- [AWS CLI v2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- [Git](https://git-scm.com/)

> 💡 *Use a Unix-like shell (Linux/macOS or WSL on Windows) for best compatibility.*

### 🔐 Configuration Required

- AWS IAM credentials with permission to manage EC2
- An EC2 SSH key pair (download the `.pem` file)
- GitHub repository with the following **secrets** configured:

| Secret Name           | Value Description                    |
|-----------------------|--------------------------------------|
| `AWS_ACCESS_KEY_ID`   | Your IAM user's access key           |
| `AWS_SECRET_ACCESS_KEY` | Your IAM user's secret key         |
| `AWS_SESSION_TOKEN`   | *(if using temporary credentials)*   |
| `KEY_PAIR_NAME`       | The name of your EC2 key pair        |
| `SSH_PRIVATE_KEY`     | Contents of your private `.pem` key  |

### 🌱 Optional: Local Environment Variables

To run locally without GitHub, export your credentials:

```bash
export AWS_ACCESS_KEY_ID=your_access_key
export AWS_SECRET_ACCESS_KEY=your_secret_key
export AWS_SESSION_TOKEN=your_session_token
```

## Pipeline Overview
```text
[Code Push to GitHub]
          ↓
[GitHub Actions Workflow]
          ↓
 terraform init + apply
          ↓
[Provision EC2 Instance]
          ↓
 ansible-playbook
          ↓
 docker-compose up
          ↓
Minecraft Server @ EC2:25565
```
---

## 📁 Repository Structure
```text
.
├── terraform/             # Infrastructure as Code
│   ├── main.tf
│   └── variables.tf
├── ansible/              
│   ├── playbook.yml       # Configures EC2 instance
│   └── inventory.ini
|   └── docker_files/
│       └── docker-compose.yml # Defines Minecraft container
|       └── docker-setup.sh
|       └── run-script.sh
├── .github/
│   └── workflows/
│       └── deploy.yml     # GitHub Actions CI/CD pipeline
├── deploy.sh              # Optional manual deploy script
└── README.md              # Project documentation
```

## Manual Commands to Run

1.) Start by cloning the GitHub repo:
```git
git clone https://github.com/shullbaz/CS312-Final.git
cd CS312-Final
```

2.) Next, update the `add_key_name` in `deploy.sh` to match your key pair name that you generated.

3.) Deploy the server by running the script in `deploy.sh`.
```bash
./deploy.sh
```
---

## Deploy Automatically with GitHub Actions (CI/CD)

1.) Getting started. Clone the repository:
```git
git clone https://github.com/shullbaz/CS312-Final.git
cd CS312-Final
```

2.) The GitHub Actions workflow triggers automatically when you push to the `main` branch, executing:
  - **Infrastructure Provisioning:** Terraform creates the EC2 instance
  - **Server Configuration:** Ansible installs and configures dependencies
  - **Container Deployment:** Docker Compose launches the Minecraft server

## Connect to New Minecraft Server

1.) Once the server is deployed, find its public IP. It will look like this:
```
<instance_ip>
```

2.) With the IP, you can check that it is running with an nmap scan.
```bash
nmap -sV -Pn -p T:25565 <instance_public_ip>
```

3.) With everything up an running, past the public IP into your Minecraft application and get to Crushing Loaf!

## More Information

- [Terraform Info](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Ansible Info & Documentation](https://docs.ansible.com/ansible/latest/index.html)
- [Minecraft Server Docker Hub Info](https://hub.docker.com/r/itzg/minecraft-server)