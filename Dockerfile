# Use the PowerShell image as the base image
FROM mcr.microsoft.com/powershell:ubuntu-22.04-arm32

# Set environment variables for Azure credentials
ENV ARM_CLIENT_ID=""
ENV ARM_CLIENT_SECRET=""
ENV ARM_SUBSCRIPTION_ID=""
ENV ARM_TENANT_ID=""
ENV ARM_SVCID_PASS=""

# Install required packages using apt (for debian-based images)
RUN apt-get update && apt-get install -y \
    jq \
    vim \
    curl \
    bash \
    net-tools \
    git \
    wget \
    unzip

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install Terraform
ENV TERRAFORM_VERSION=0.15.5
RUN curl -LO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
    && unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -d /usr/local/bin \
    && rm "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

# Create a working directory
WORKDIR /app

# Mount your ARM templates, PowerShell scripts, and Terraform scripts into the container
VOLUME ["/app/arm-templates", "/app/powershell-scripts", "/app/terraform-scripts"]

# Set the entry point to execute PowerShell scripts
ENTRYPOINT [ "pwsh", "-c" ]

# Default command to run when the container starts
CMD [ "Write-Host", "'Specify a PowerShell command to execute.'" ]
