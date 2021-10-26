param vnetName string
param location string
param vnetAddressPrefix string
param bastionSubnetName string
param bastionSubnetAddressPrefix string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: bastionSubnetName
        properties: {
          addressPrefix: bastionSubnetAddressPrefix
          networkSecurityGroup: {
            id: resourceId('Microsoft.Network/networkSecurityGroups', bastionSubnetName)
          }
        }
      }
    ]
    enableDdosProtection: false
    enableVmProtection: false
  }
}
