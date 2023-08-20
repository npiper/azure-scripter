#!/bin/bash

# Authenticate with Azure
az login --service-principal --username "$ARM_CLIENT_ID" --password "$ARM_CLIENT_SECRET" --tenant "$ARM_TENANT_ID"


# Define environment variables
resourceGroupName="UKSouthResourceGroup"
location="uksouth"
vmName="MyUKSouthVM"
adminUsername="adminuser"
adminPassword="P@ssw0rd1234567"
subnetName="SubnetUKSouth"
vnetName="VNetUKSouth"
webServerScript="/app/powershell-scripts/webServerScript.psh"

# Create a resource group
echo "Creating resource group..."
az group create --name $resourceGroupName --location $location

# Create a virtual network
echo "Creating virtual network..."
az network vnet create --resource-group $resourceGroupName --name $vnetName --address-prefixes "10.0.0.0/16" --location $location

# Create a subnet
echo "Creating subnet..."
az network vnet subnet create --resource-group $resourceGroupName --vnet-name $vnetName --name $subnetName --address-prefix "10.0.1.0/24"

# Create a public IP
echo "Creating public IP..."
az network public-ip create --resource-group $resourceGroupName --name "${vmName}-pip" --location $location --allocation-method Dynamic

# Create a NIC
echo "Creating network interface..."
az network nic create --resource-group $resourceGroupName --name "${vmName}-nic" --vnet-name $vnetName --subnet $subnetName --public-ip-address "${vmName}-pip"

# Create a virtual machine
echo "Creating virtual machine..."
az vm create --resource-group $resourceGroupName --name $vmName --size "Standard_B1ms" --admin-username $adminUsername --admin-password $adminPassword --image "Canonical:UbuntuServer:16.04-LTS:latest" --nics "${vmName}-nic"

# Install Apache and copy test page
echo "Installing Apache..."
az vm run-command invoke --resource-group $resourceGroupName --name $vmName --command-id "RunShellScript" --scripts "$webServerScript"

# Display VM details
echo "Displaying VM details..."
az vm show --resource-group $resourceGroupName --name $vmName --show-details --output table

# Disconnect from Azure
echo "Disconnecting from Azure..."
az logout
