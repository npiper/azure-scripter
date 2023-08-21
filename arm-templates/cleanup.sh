#!/bin/bash

# Authenticate with Azure
az login --service-principal --username "$ARM_CLIENT_ID" --password "$ARM_CLIENT_SECRET" --tenant "$ARM_TENANT_ID"

# Define environment variables
resourceGroupName="UKSouthResourceGroup"
recoveryResourceGroupName="RecoveryResourceGroup"
vmName="MyUKSouthVM"

# Delete the recovery vault and its contents
echo "Deleting recovery vault and its contents..."
az backup vault delete --name "RecoveryVault" --resource-group $recoveryResourceGroupName --yes

# Delete the recovery resource group
echo "Deleting recovery resource group..."
az group delete --name $recoveryResourceGroupName --yes --no-wait

# Delete the resource group for the primary region and its contents
echo "Deleting resource group for the primary region and its contents..."
az group delete --name $resourceGroupName --yes --no-wait

# Disconnect from Azure
echo "Disconnecting from Azure..."
az logout
