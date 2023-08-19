# Use a base image with Azure CLI, PowerShell, and other tools
FROM mcr.microsoft.com/azure-cli

# Set environment variables for Azure credentials
ENV ARM_CLIENT_ID=""
ENV ARM_CLIENT_SECRET=""
ENV ARM_SUBSCRIPTION_ID=""
ENV ARM_TENANT_ID=""
ENV ARM_SVCID_PASS=""

# Install required packages
# Install required packages using apk

RUN apk update && apk add \
    jq \
    vim \
    curl \
    bash \
    net-tools \
    busybox-extras \
    git \
    wget \
    unzip \
    powershell
 # Add more packages as needed


# Install Terraform
ENV TERRAFORM_VERSION=0.15.5
RUN curl -LO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
    && unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -d /usr/local/bin \
    && rm "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

# Create a working directory
WORKDIR /app

# Copy your ARM templates, PowerShell scripts, and Terraform scripts to the container
COPY ./arm-templates /app/arm-templates
COPY ./powershell-scripts /app/powershell-scripts
COPY ./terraform-scripts /app/terraform-scripts

# Set the entry point to execute ARM templates, PowerShell scripts, and Terraform scripts
ENTRYPOINT [ "bash", "-c" ]

# Default command to run when the container starts
CMD [ "echo 'Specify a command to execute.'" ]
