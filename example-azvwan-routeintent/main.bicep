targetScope = 'resourceGroup'

metadata generic = {
  synopsis: 'This templates deploys azure virtual wan with Route Intent Policy for demo purposes ONLY'
  description: 'Basic virtual wan with route intent policy demo'
}
@sys.description('The region to deploy all resources into')
param parLocation string = 'westeurope'
@sys.description('Id of the azure subscription')
param parSubscriptionId string = subscription().subscriptionId
@sys.description('the name of the resource group')
param parResourceGroupNames array
@sys.description('name of the virtual network')
param parVirtualNetworkName string
@sys.description('address space of the virtual network')
param parVnetAddressPrefixes array
@sys.description('the name of the subnet')
param parSubnetName string
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

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param parDiagnosticMetricsToEnable array = [
  'AllMetrics'
]

var diagnosticsLogsSpecified = [for category in filter(parDiagnosticLogCategoriesToEnable, item => item != 'allLogs'): {
  category: category
  enabled: true
  retentionPolicy: {
    enabled: true
    days: parDiagnosticLogsRetentionInDays
  }
}]

var diagnosticsLogs = contains(parDiagnosticLogCategoriesToEnable, 'allLogs') ? [
  {
    categoryGroup: 'allLogs'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: parDiagnosticLogsRetentionInDays
    }
  }
] : diagnosticsLogsSpecified

var diagnosticsMetrics = [for metric in parDiagnosticMetricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
  retentionPolicy: {
    enabled: true
    days: parDiagnosticLogsRetentionInDays
  }
}]

var parSubnetAddress = cidrSubnet(parVnetAddressPrefixes[0], 24, 1)

var subnetObject = [ parSubnetName, parSubnetAddress ]

module modResourceGroup '../AzureModules/modules/Microsoft.Resources/resourceGroups/deploy.bicep' = [for rg in parResourceGroupNames: {
  scope: subscription(parSubscriptionId)
  name: 'mod_${rg}'
  params: {
    name: rg
    location: parLocation
    enableDefaultTelemetry: false
  }
}]

module modLogAnalyticsWorkspace '../AzureModules/modules/Microsoft.OperationalInsights/workspaces/deploy.bicep' = {
  name: 'mod_${parLogAnalyticsWorkspaceName}'
  params: {
    name: parLogAnalyticsWorkspaceName
    location: parLocation
    enableDefaultTelemetry: false
  }
}

module modVirtualNetwork '../AzureModules/modules/microsoft.network/virtualNetworks/deploy.bicep' = {
  scope: resourceGroup(parSubscriptionId, parResourceGroupNames[1])
  name: 'mod_${parVirtualNetworkName}'
  params: {
    addressPrefixes: parVnetAddressPrefixes
    subnets: subnetObject
    name: parVirtualNetworkName
    location: parLocation
    enableDefaultTelemetry: false
  }
}

module modVirtualWan '../AzureModules/modules/microsoft.network/virtualWans/deploy.bicep' = {
  scope: resourceGroup(parSubscriptionId, parResourceGroupNames[0])
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
  scope: resourceGroup(parSubscriptionId, parResourceGroupNames[0])
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
  scope: resourceGroup(parSubscriptionId, parResourceGroupNames[0])
  name: 'mod_${parAzFirewallName}'
  params: {
    name: parAzFirewallName
    location: parLocation
    azureSkuTier: 'Standard'
    virtualHubId: modVirtualHub.outputs.resourceId
    tags: parTags
    enableDefaultTelemetry: false
  }
}

resource azureFirewall_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: !empty(parDiagnosticSettingsName) ? parDiagnosticSettingsName : '${parAzFirewallName}-diagnosticSettings'
  properties: {
    workspaceId: !empty(modLogAnalyticsWorkspace.outputs.resourceId) ? modLogAnalyticsWorkspace.outputs.resourceId : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
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
  }
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

module modRouteIntentPolicy 'modules/routeingIntent/routeingIntent.bicep' = {
  name: 'mod_${parRoutingIntentName}'
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
