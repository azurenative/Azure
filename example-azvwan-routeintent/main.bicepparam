using 'main.bicep'

param parLocation = 'westeurope'
param parVirtualNetworkName = 'vnet-hub-weu-01'
param parVnetAddressPrefixes = [ '10.10.0.0/16' ]
param parVirtualWanName = 'vwan-azn-weu-01'
param parVirtualHubName = 'vhub-azn-weu-01'
param parAzFirewallName = 'afw-azn-weu-01'
param parAzFirewallPoliciesName = 'RouteIntentPolicy'
param parTags = {
  createdby: 'Joe Tahsin'
  purpose: 'demo azure vwan route intent policies'
}
param parRoutingIntentName = 'routeintentpolicy'
param parDiagnosticSettingsName = 'azfw_diagnosticlogs'
param parLogAnalyticsWorkspaceName = 'law-azn-demo-01'
param parDiagnosticLogsRetentionInDays = 30
param parDiagnosticLogCategoriesToEnable = [
  'allLogs'
]
