targetScope = 'subscription'

module resourceGroupModule 'ts/mytemplatespecs:resourcegroup:0.1' = {
  name: 'justaresourcegroup'
  params: {
    location: 'westeurope'
    tags: {
      createdby: 'Joe Tahsin'
      purpose: 'demo template specs as modules'
    }
    resourceGroupName: 'rg-vnetpeering'
  }
}

module demovnet01 'ts/mytemplatespecs:virtualNetwork:0.2' = {
  name: 'justavirtualnetwork1'
  scope: resourceGroup('rg-vnetpeering')
  params: {
    location: 'westeurope'
    addressPrefixes: '10.16.0.0/16'
    subnetAdresPrefix: '10.16.2.0/24'
    subnetName: 'demosubnet01'
    virtualNetworkName: 'demovnet01'
  }
  dependsOn: [
    resourceGroupModule
  ]
}

module demovnet02 'ts/mytemplatespecs:virtualNetwork:0.1' = {
  name: 'justavirtualnetwork2'
  scope: resourceGroup('rg-vnetpeering')
  params: {
    location: 'westeurope'
    tags: {
      createdby: 'Joe Tahsin'
      purpose: 'demo template specs as modules'
    }
    addressPrefixes: '10.15.0.0/16'
    subnetAdresPrefix: '10.15.2.0/24'
    subnetName: 'demosubnet02'
    virtualNetworkName: 'demovnet02'
  }
  dependsOn: [
    resourceGroupModule
    demovnet01
  ]
}

module demovnetpeering 'ts/mytemplatespecs:virtualNetworkPeering:0.1' = {
  name: 'justavnetpeering'
  scope: resourceGroup('rg-vnetpeering')
  params: {    
    ResourceGroupName: resourceGroupModule.outputs.resourceGroupName
    hubVnetName: demovnet01.outputs.virtualNetworkName 
    spokeVnetName: demovnet02.outputs.virtualNetworkName
  }
  dependsOn: [
    demovnet01
    demovnet02
  ]
}
