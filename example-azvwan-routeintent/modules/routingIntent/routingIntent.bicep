@sys.description('name of the virtula hub')
param parVirtualHubName string
@sys.description('name of the route intent policy')
param parRoutingIntentName string
@sys.description('resource id of the azure firewall')
param parAzFirewallResourceId string

resource resVhub 'Microsoft.Network/virtualHubs@2022-11-01' existing = {
  name: parVirtualHubName
}

resource resroutingIntent 'Microsoft.Network/virtualHubs/routingIntent@2022-07-01' = {
  parent: resVhub
  name: parRoutingIntentName
  properties: {
    routingPolicies: [
      {
        destinations: [
          'Internet'
        ]
        name: 'Internet'
        nextHop: parAzFirewallResourceId
      }
      {
        destinations: [
          'PrivateTraffic'
        ]
        name: 'PrivateTraffic'
        nextHop: parAzFirewallResourceId
      }
    ]
  }
}
