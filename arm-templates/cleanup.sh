#!/bin/bash

# Authenticate with Azure
az login --service-principal --username "$ARM_CLIENT_ID" --password "$ARM_CLIENT_SECRET" --tenant "$ARM_TENANT_ID"

# Define environment variables
resourceGroupName="UKSouthResourceGroup"
recoveryVaultName="MyRecoveryVault"
vmName="MyUKSouthVM"

# Delete the virtual machine
echo "Deleting virtual machine..."
az vm delete --resource-group $resourceGroupName --name $vmName --yes --no-wait

# Delete the Recovery Vault
echo "Deleting Recovery Vault..."
az backup vault delete --name $recoveryVaultName --resource-group $resourceGroupName --yes

# Delete the resource group
echo "Deleting resource group..."
az group delete --name $resourceGroupName --yes --no-wait

# Disconnect from Azure
echo "Disconnecting from Azure..."
az logout
