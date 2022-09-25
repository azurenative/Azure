param bastionSubnetName string
param location string

resource nsgBastion 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name : bastionSubnetName
  location : location
  properties : {
    securityRules : [
      {
        name : 'AllowOMSAgent'
        properties : {
          protocol :'Tcp'
          sourcePortRange : '*'
          destinationPortRange : '*'
          sourceAddressPrefix : 'AzureMonitor'
          destinationAddressPrefix : '*'
          access : 'Allow'
          priority : 110
          direction : 'Outbound'
        }
      }
      {
        name : 'AllowAzureMonitor'
        properties : {
          protocol :'Tcp'
          sourcePortRange : '*'
          destinationPortRange : '*'
          sourceAddressPrefix : 'AzureBackup'
          destinationAddressPrefix : '*'
          access : 'Allow'
          priority : 120
          direction : 'Outbound'
        }
      }
      {
        name : 'AllowHttpsInbound'
        properties : {
          protocol : 'Tcp'
          sourcePortRange : '*'
          destinationPortRange : '*'
          sourceAddressPrefix : '*'
          destinationAddressPrefix : '*'
          access : 'Allow'
          priority : 130
          direction : 'Inbound'
        }
      }
      {
        name : 'AllowGatewayManagerInbound'
        properties : {
          protocol : 'Tcp'
          sourcePortRange : '*'
          destinationPortRange : '*'
          sourceAddressPrefix : 'GatewayManager'
          destinationAddressPrefix : '*'
          access : 'Allow'
          priority : 140
          direction : 'Inbound'
        }
      }      
      {
        name : 'AllowLoadBalancerInbound'
        properties : {
          protocol : 'Tcp'
          sourcePortRange : '*'
          destinationPortRange : '*'
          sourceAddressPrefix : 'AzureLoadBalancer'
          destinationAddressPrefix : '*'
          access : 'Allow'
          priority : 150
          direction : 'Inbound'
        }
      }      
      {
        name : 'AllowBastionHostCommunication'
        properties : {
          protocol : '*'
          sourcePortRange : '*'
          destinationPortRange : '*'
          sourceAddressPrefix : 'VirtualNetwork'
          destinationAddressPrefix : 'VirtualNetwork'
          access : 'Allow'
          priority : 160
          direction : 'Inbound'
        }
      }
      {
        name : 'AllowSshRdpOutbound'
        properties : {
          protocol : '*'
          sourcePortRange : '*'
          destinationPortRange : '*'
          sourceAddressPrefix : '*'
          destinationAddressPrefix : 'VirtualNetwork'
          access : 'Allow'
          priority : 170
          direction : 'Outbound'
        }
      }
      {
        name : 'AllowAzureCloudOutbound'
        properties : {
          protocol : 'Tcp'
          sourcePortRange : '*'
          destinationPortRange : '*'
          sourceAddressPrefix : '*'
          destinationAddressPrefix : 'AzureCloud'
          access : 'Allow'
          priority : 180
          direction : 'Outbound'
        }
      }      
      {
        name : 'AllowBastionCommunication'
        properties : {
          protocol : '*'
          sourcePortRange : '*'
          destinationPortRange : '*'
          sourceAddressPrefix : 'VirtualNetwork'
          destinationAddressPrefix : 'VirtualNetwork'
          access : 'Allow'
          priority : 190
          direction : 'Outbound'
        }
      }      
      {
        name : 'AllowGetSessionsCommunication'
        properties : {
          protocol : '*'
          sourcePortRange : '*'
          destinationPortRange : '*'
          sourceAddressPrefix : 'Internet'
          destinationAddressPrefix : '*'
          access : 'Allow'
          priority : 200
          direction : 'Outbound'
        }
      }          
    ]
  }
}
