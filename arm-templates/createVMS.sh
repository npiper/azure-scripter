# Authenticate with Azure
az login --service-principal --username "$ARM_CLIENT_ID" --password "$ARM_CLIENT_SECRET" --tenant "$ARM_TENANT_ID"

# Define environment variables
resourceGroupName="UKSouthResourceGroup"
recoveryResourceGroupName="RecoveryResourceGroup"
location="uksouth"
recoveryLocation="ukwest"  # Location for the recovery region
vmName="MyUKSouthVM"
adminUsername="adminuser"
adminPassword="P@ssw0rd123!"  # Updated password
subnetName="SubnetUKSouth"
vnetName="VNetUKSouth"
webServerScript="/app/powershell-scripts/webServerScript.psh"

# Create a resource group for the primary region
echo "Creating resource group for the primary region..."
az group create --name $resourceGroupName --location $location

# Create a virtual network in the primary region
echo "Creating virtual network in the primary region..."
az network vnet create --resource-group $resourceGroupName --name $vnetName --address-prefixes "10.0.0.0/16" --subnet-name $subnetName --subnet-prefixes "10.0.1.0/24"

# Create a subnet in the primary region
echo "Creating subnet in the primary region..."
az network vnet subnet create --resource-group $resourceGroupName --vnet-name $vnetName --name $subnetName --address-prefixes "10.0.1.0/24"

# Create a recovery resource group
echo "Creating recovery resource group..."
az group create --name $recoveryResourceGroupName --location $recoveryLocation

# Create a virtual network in the recovery region
echo "Creating virtual network in the recovery region..."
az network vnet create --resource-group $recoveryResourceGroupName --name "${vnetName}-recovery" --address-prefixes "10.1.0.0/16"

# Create a subnet in the recovery region
echo "Creating subnet in the recovery region..."
az network vnet subnet create --resource-group $recoveryResourceGroupName --vnet-name "${vnetName}-recovery" --name "${subnetName}-recovery" --address-prefix "10.1.1.0/24"

# Create a recovery vault
echo "Creating recovery vault..."
az backup vault create --name "RecoveryVault" --resource-group $resourceGroupName --location $location


# Create the virtual machine
echo "Creating the virtual machine..."
az vm create \
  --resource-group $resourceGroupName \
  --name $vmName \
  --image Ubuntu2204 \
  --public-ip-sku Standard \
  --admin-username $adminUsername \
  --admin-password $adminPassword \
  --vnet-name $vnetName \
  --subnet $subnetName \
  --location $location

# Wait for the VM to be provisioned
echo "Waiting for the virtual machine to be provisioned..."
while [[ $(az vm show -d -g $resourceGroupName -n $vmName --query provisioningState -o tsv) != "Succeeded" ]]; do
    echo "VM provisioning state: $(az vm show -d -g $resourceGroupName -n $vmName --query provisioningState -o tsv)"
    sleep 10
done


echo "Resource Group Name: $resourceGroupName"
echo "Recovery Resource Group Name: $recoveryResourceGroupName"


# Get the VM ID
vmId=$(az vm show -g $resourceGroupName -n $vmName --query id --output tsv)

# Configure the VM for disaster recovery
echo "Configuring VM for disaster recovery..."
az backup protection enable-for-vm --resource-group $resourceGroupName --vault-name "RecoveryVault" --vm $vmId --policy-name "DefaultPolicy"


# Wait for the policy to be applied
echo "Waiting for policy to be applied..."
while [[ $(az backup protection show --resource-group $resourceGroupName --vault-name "RecoveryVault" --container-name $vmName --query properties.policyState -o tsv) != "Succeeded" ]]; do
    echo "Policy state: $(az backup protection show --resource-group $resourceGroupName --vault-name "RecoveryVault" --container-name $vmName --query properties.policyState -o tsv)"
    sleep 10
done

# Install Azure Site Recovery extension on the VM
echo "Installing Azure Site Recovery extension..."
az vm extension set --resource-group $resourceGroupName --vm-name $vmName --name "AzureSiteRecoveryAgent" --publisher "Microsoft.Azure.RecoveryServices" --version "2.0" --settings "{}"

az vm extension set --resource-group "UKSouthResourceGroup" --vm-name "MyUKSouthVM" --name "AzureSiteRecoveryAgent" --publisher "Microsoft.Azure.RecoveryServices" --version "2.0" --settings "{}"


# Display VM details
echo "Displaying VM details..."
az vm show --resource-group $resourceGroupName --name $vmName --show-details --output table

# Disconnect from Azure
echo "Disconnecting from Azure..."
az logout
