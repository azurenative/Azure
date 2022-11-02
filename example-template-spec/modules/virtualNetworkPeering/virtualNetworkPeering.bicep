targetScope  = 'resourceGroup'
// var version = '1.0'
// var templateSpecName = 'virtualNetworkPeering'
param hubVnetName string
param spokeVnetName string
param ResourceGroupName string


resource hubToSpokeNetworkPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-05-01' = {
  name: '${hubVnetName}/${hubVnetName}TO${spokeVnetName}-01'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: true
    useRemoteGateways: false
    peeringSyncLevel: 'FullyInSync'
    peeringState: 'Connected'
    remoteVirtualNetwork: {
      id: resourceId(ResourceGroupName, 'Microsoft.Network/virtualNetworks', spokeVnetName)
    }
  }
}

resource spokeToHubPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-05-01' =  {
  name: '${spokeVnetName}/${spokeVnetName}TO${hubVnetName}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: true
    useRemoteGateways: false
    peeringSyncLevel: 'FullyInSync'
    peeringState: 'Connected'
    remoteVirtualNetwork: {
      id: resourceId(ResourceGroupName, 'Microsoft.Network/virtualNetworks', hubVnetName)
    }
  }
}





