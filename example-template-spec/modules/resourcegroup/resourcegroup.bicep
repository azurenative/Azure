targetScope = 'subscription'
@description('location of the azure region')
param location string
@description('Name of the Resource Group')
param resourceGroupName string
@description('contains default tags values')
param tags object

resource ResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

output resourceGroupName string = ResourceGroup.name
