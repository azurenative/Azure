targetScope  = 'resourceGroup'
param hubVnetName string
param spokeVnetName string
param hubResourceGroupName string
param spokeResourceGroupName string
param spokeVnetPeeringOnly bool
param hubPeeringOnly bool

resource hubToSpokeNetworkPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-05-01' = if(hubPeeringOnly == true) {
  name: '${hubVnetName}TO${spokeVnetName}-01'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: true
    useRemoteGateways: false
    peeringSyncLevel: 'FullyInSync'
    peeringState: 'Connected'
    remoteVirtualNetwork: {
      id: resourceId(spokeResourceGroupName, 'Microsoft.Network/virtualNetworks', spokeVnetName)
    }
  }
}

resource spokeToHubPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-05-01' = if(spokeVnetPeeringOnly == true) {
  name: '${spokeVnetName}TO${hubVnetName}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: true
    useRemoteGateways: false
    peeringSyncLevel: 'FullyInSync'
    peeringState: 'Connected'
    remoteVirtualNetwork: {
      id: resourceId(hubResourceGroupName, 'Microsoft.Network/virtualNetworks', hubVnetName)
    }
  }
}





