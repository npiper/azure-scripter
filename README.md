# Azure Scripting Environment Docker Image ��

This Docker image provides a scripting environment for managing Azure environments using the Azure CLI, Terraform, and PowerShell. It's equipped with essential tools and utilities to streamline your scripting and infrastructure-as-code tasks.

## Features

✅ Azure CLI for managing Azure resources
✅ Terraform for infrastructure provisioning
✅ PowerShell for automation and scripting
✅ Additional tools and utilities: jq, vim, curl, bash, net-tools, git, unzip

## Getting Started

### Build the Docker Image

To build the Docker image, navigate to the directory containing the Dockerfile and execute the following command:

```sh
docker build -t azure-scripting-env .

## Run the Docker Container

To run the Docker container and start an interactive shell session, use the following command:

```
docker run -it --rm \
  -e ARM_CLIENT_ID=your_client_id \
  -e ARM_SUBSCRIPTION_ID=your_subscription_id \
  -e ARM_CLIENT_SECRET=your_client_secret \
  -e ARM_TENANT_ID=your_tenant_id \
  -e ARM_SVCID_PASS=your_service_principal_password \
  azure-scripting-env
```

Replace the placeholders (your_client_id, your_subscription_id, etc.) with your actual Azure credentials and values.

Contributing
Contributions are welcome! If you encounter any issues, have suggestions, or want to contribute improvements, follow these steps:

Create an issue on the GitHub repository to discuss your idea or problem.
Fork the repository.
Create a new branch with a descriptive name (feature/my-feature or bugfix/issue-123).
Make your changes and ensure that your code adheres to best practices.
Create a pull request from your branch to the main repository's main branch.
Provide a detailed description of your changes in the pull request.
Let's work together to make this Docker image even better! 👥
