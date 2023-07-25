targetScope = 'resourceGroup'

metadata generic = {
  synopsis: 'This templates deploys azure virtual wan with Route Intent Policy for demo purposes ONLY'
  description: 'Basic virtual wan with route intent policy demo'
}
@sys.description('The region to deploy all resources into')
param parLocation string = 'westeurope'
@sys.description('name of the virtual network')
param parVirtualNetworkName string
@sys.description('address space of the virtual network')
param parVnetAddressPrefixes array
@sys.description('the name of the virtual wan')
param parVirtualWanName string
@sys.description('name of the virtual hub')
param parVirtualHubName string
@sys.description('name of the Azure Firewall')
param parAzFirewallName string
@sys.description('name of the azure firewall policy')
param parAzFirewallPoliciesName string
@sys.description('contains object of tag values')
param parTags object
@sys.description('the name of the routing intent policy')
param parRoutingIntentName string
@sys.description('the name of the diagnosticsettings')
param parDiagnosticSettingsName string
@sys.description('the name of the log analytics workspace')
param parLogAnalyticsWorkspaceName string
@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param parDiagnosticLogsRetentionInDays int = 30
@description('Diagnostic log catagories enabled')
param parDiagnosticLogCategoriesToEnable array = [
  'allLogs'
]

var HubIPAddresses = {
  publicIPs: {
    count: 1
  }
}

module modLogAnalyticsWorkspace '../AzureModules/modules/Microsoft.OperationalInsights/workspaces/deploy.bicep' = {
  name: 'mod_${parLogAnalyticsWorkspaceName}'
  params: {
    name: parLogAnalyticsWorkspaceName
    location: parLocation
    enableDefaultTelemetry: false
    tags: parTags
  }
}

module modVirtualNetwork '../AzureModules/modules/microsoft.network/virtualNetworks/deploy.bicep' = {
  name: 'mod_${parVirtualNetworkName}'
  params: {
    addressPrefixes: parVnetAddressPrefixes
    name: parVirtualNetworkName
    location: parLocation
    enableDefaultTelemetry: false
    tags: parTags
  }
}

module modVirtualWan '../AzureModules/modules/microsoft.network/virtualWans/deploy.bicep' = {
  name: 'mod_${parVirtualWanName}'
  params: {
    name: parVirtualWanName
    location: parLocation
    enableDefaultTelemetry: false
    tags: parTags
  }
  dependsOn: [
    modVirtualNetwork
  ]
}

module modVirtualHub '../AzureModules/modules/Microsoft.Network/virtualHubs/deploy.bicep' = {
  name: parVirtualHubName
  params: {
    location: parLocation
    addressPrefix: parVnetAddressPrefixes[0]
    name: parVirtualHubName
    sku: 'Standard'
    virtualWanId: modVirtualWan.outputs.resourceId
    enableDefaultTelemetry: false
    tags: parTags
  }
  dependsOn: [
    modVirtualNetwork
    modVirtualWan
  ]
}

module modAzFirewall '../AzureModules/modules/microsoft.network/azureFirewalls/deploy.bicep' = {
  name: 'mod_${parAzFirewallName}'
  params: {
    name: parAzFirewallName
    location: parLocation
    azureSkuTier: 'Standard'
    virtualHubId: modVirtualHub.outputs.resourceId
    tags: parTags
    hubIPAddresses: HubIPAddresses
    enableDefaultTelemetry: false
  }
}

module modAFW_diagnosticSettings '../AzureModules/modules/Microsoft.Insights/diagnosticSettings/deploy.bicep' = {
  scope: subscription('439c1009-ab52-4ec2-820d-1af8b058c9cd')
  name: 'mod_afwDiagnosticSettings'
  params: {
    name: !empty(parDiagnosticSettingsName) ? parDiagnosticSettingsName : '${parAzFirewallName}-diagnosticSettings'
    location: parLocation
    enableDefaultTelemetry: false
    diagnosticWorkspaceId: modLogAnalyticsWorkspace.outputs.resourceId
    diagnosticLogCategoriesToEnable: parDiagnosticLogCategoriesToEnable
    diagnosticLogsRetentionInDays: parDiagnosticLogsRetentionInDays
  }
  dependsOn: [
    modAzFirewall
  ]
}

module modHubDefaultRouteTable '../AzureModules/modules/microsoft.network/virtualHubs/hubRouteTables/deploy.bicep' = {
  name: 'mod_defaultHubRouteTable'
  params: {
    name: 'default'
    virtualHubName: modVirtualHub.outputs.name
    enableDefaultTelemetry: false
  }
}

module modHubNoneRouteTable '../AzureModules/modules/microsoft.network/virtualHubs/hubRouteTables/deploy.bicep' = {
  name: 'mod_NoneHubRouteTable'
  params: {
    name: 'noneRouteTable'
    virtualHubName: modVirtualHub.outputs.name
    enableDefaultTelemetry: false
    labels: [
      'none'
    ]
  }
  dependsOn: [
    modHubDefaultRouteTable
  ]
}

module modFirewallPolicies '../AzureModules/modules/microsoft.network/firewallPolicies/deploy.bicep' = {
  name: 'mod_${parAzFirewallPoliciesName}'
  params: {
    name: parAzFirewallPoliciesName
    location: parLocation
    mode: 'Off'
    tags: parTags
    tier: 'Standard'
    enableDefaultTelemetry: false
  }
  dependsOn: [
    modAzFirewall
  ]
}

module modRouteIntentPolicy 'modules/routingIntent/routingIntent.bicep' = {
  name: 'mod_${parRoutingIntentName}-1'
  params: {
    parAzFirewallResourceId: modAzFirewall.outputs.resourceId
    parRoutingIntentName: parRoutingIntentName
    parVirtualHubName: parVirtualHubName

  }
  dependsOn: [
    modVirtualHub
    modAzFirewall
    modHubDefaultRouteTable
    modHubNoneRouteTable
    modFirewallPolicies
  ]
}
