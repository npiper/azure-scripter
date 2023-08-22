#!/bin/bash

# Authenticate with Azure
az login --service-principal --username "$ARM_CLIENT_ID" --password "$ARM_CLIENT_SECRET" --tenant "$ARM_TENANT_ID"

# Define environment variables
resourceGroupName="UKSouthResourceGroup"
recoveryResourceGroupName="RecoveryResourceGroup"
vmName="MyUKSouthVM"
recoveryVaultName="RecoveryVault"

# Remove backup protection from the VM
echo "Disabling backup protection for the VM..."
az backup protection delete --resource-group $resourceGroupName --vault-name $recoveryVaultName --item-name $vmName --yes

# Remove the VM's protection intent from the vault
echo "Removing the VM's protection intent from the vault..."
az backup protection intent remove --resource-group $resourceGroupName --vault-name $recoveryVaultName --item-name $vmName

# Delete the VM from the backup vault
echo "Deleting the VM from the backup vault..."
az backup item delete --resource-group $resourceGroupName --vault-name $recoveryVaultName --item-name $vmName

# Delete the recovery vault
echo "Deleting the recovery vault..."
az backup vault delete --name $recoveryVaultName --resource-group $recoveryResourceGroupName --yes


# Delete the recovery resource group
echo "Deleting recovery resource group..."
az group delete --name $recoveryResourceGroupName --yes --no-wait

# Delete the resource group for the primary region and its contents
echo "Deleting resource group for the primary region and its contents..."
az group delete --name $resourceGroupName --yes --no-wait

# Disconnect from Azure
echo "Disconnecting from Azure..."
az logout
