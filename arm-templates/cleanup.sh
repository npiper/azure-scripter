#!/bin/bash

# Authenticate with Azure
az login --service-principal --username "$ARM_CLIENT_ID" --password "$ARM_CLIENT_SECRET" --tenant "$ARM_TENANT_ID"

# Define environment variables
resourceGroupName="UKSouthResourceGroup"
location="uksouth"
vmName="MyUKSouthVM"

# Delete virtual machine if exists
echo "Deleting virtual machine if exists..."
az vm delete --resource-group $resourceGroupName --name $vmName --yes --no-wait 2>/dev/null

# Delete resource group and all resources
echo "Deleting resource group and all resources..."
az group delete --name $resourceGroupName --yes --no-wait

# Disconnect from Azure
echo "Disconnecting from Azure..."
az logout