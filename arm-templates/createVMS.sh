# Authenticate with Azure
az login --service-principal --username "$ARM_CLIENT_ID" --password "$ARM_CLIENT_SECRET" --tenant "$ARM_TENANT_ID"

# Define environment variables
resourceGroupName="UKSouthResourceGroup"
recoveryResourceGroupName="RecoveryResourceGroup"
location="uksouth"
recoveryLocation="ukwest"  # Location for the recovery region
vmName="MyUKSouthVM"
adminUsername="adminuser"
adminPassword="P@ssw0rd123"
subnetName="SubnetUKSouth"
vnetName="VNetUKSouth"
webServerScript="/app/powershell-scripts/webServerScript.psh"

# Create a resource group for recovery
echo "Creating recovery resource group..."
az group create --name $recoveryResourceGroupName --location $recoveryLocation

# Create a virtual network in the recovery region
echo "Creating virtual network in recovery region..."
az network vnet create --resource-group $recoveryResourceGroupName --name "${vnetName}-recovery" --address-prefixes "10.0.0.0/16" --location $recoveryLocation

# Create a subnet in the recovery region
echo "Creating subnet in recovery region..."
az network vnet subnet create --resource-group $recoveryResourceGroupName --vnet-name "${vnetName}-recovery" --name "${subnetName}-recovery" --address-prefix "10.0.1.0/24"

# Create a recovery vault
echo "Creating recovery vault..."
az backup vault create --name "RecoveryVault" --resource-group $recoveryResourceGroupName --location $recoveryLocation

# Configure the VM for disaster recovery
echo "Configuring VM for disaster recovery..."
az backup protection enable-for-vm --resource-group $resourceGroupName --vault-name "RecoveryVault" --vm $vmName --policy-name "DefaultPolicy"

# Wait for the policy to be applied
echo "Waiting for policy to be applied..."
sleep 300  # Wait for 5 minutes (adjust as needed)

# Install Azure Site Recovery extension on the VM
echo "Installing Azure Site Recovery extension..."
az vm extension set --resource-group $resourceGroupName --vm-name $vmName --name "AzureSiteRecoveryAgent" --publisher "Microsoft.Azure.RecoveryServices" --version "2.0" --settings "{}"

# Display VM details
echo "Displaying VM details..."
az vm show --resource-group $resourceGroupName --name $vmName --show-details --output table

# Disconnect from Azure
echo "Disconnecting from Azure..."
az logout