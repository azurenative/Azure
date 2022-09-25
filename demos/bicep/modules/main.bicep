targetScope = 'subscription'
param vnetName string
param location string
param subnetName string
param bastionSubnetName string
param bastionResourceName string
param vnetAddressPrefix string
param bastionSubnetAddressPrefix string
param resourceGroupName string
param networkSecurityGroupName string

resource ResourceGroupBastion 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module virtualNetworkResource 'vnet.bicep' = {
  name: 'vnet-${vnetName}'
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    ResourceGroupBastion
  ]
  params: {
    location: location
    vnetAddressPrefix: vnetAddressPrefix
    vnetName: vnetName
    bastionSubnetAddressPrefix: bastionSubnetAddressPrefix
    bastionSubnetName: bastionSubnetName
  }
}

module networkSecurityGroupResource 'networksecuritygroups.bicep' = {
  name: 'nsg--${networkSecurityGroupName}'
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    ResourceGroupBastion
    virtualNetworkResource
  ]
  params: {
    location: location
    bastionSubnetName: bastionSubnetName
  }
}

module bastionResource './bastion.bicep' = {
  name: 'bastion--${bastionResourceName}'
  scope : resourceGroup(resourceGroupName)
  dependsOn: [
    ResourceGroupBastion
    networkSecurityGroupResource
  ]
  params: {
    location: location
    bastionResourceName: bastionResourceName 
  }
}
