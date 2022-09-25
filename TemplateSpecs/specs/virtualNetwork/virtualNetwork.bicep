targetScope = 'resourceGroup'
param addressPrefixes string
param location string
param subnetName string
param subnetAdresPrefix string
param tags object
param virtualNetworkName string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: virtualNetworkName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefixes
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetAdresPrefix
        }
      }
    ]
  }
}
