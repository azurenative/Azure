using './main.bicep'

param parLocation = 'westeurope'
param parSubscriptionId = ''
param parResourceGroupNames = []
param parVirtualNetworkName = ''
param parVnetAddressPrefixes = []
param parSubnetName = ''
param parVirtualWanName = ''
param parVirtualHubName = ''
param parAzFirewallName = ''
param parAzFirewallPoliciesName = ''
param parTags = {}
param parRoutingIntentName = ''
param parDiagnosticSettingsName = ''
param parLogAnalyticsWorkspaceName = ''
param parDiagnosticLogsRetentionInDays = 30
param parDiagnosticLogCategoriesToEnable = [
  'allLogs'
]
param parDiagnosticMetricsToEnable = [
  'AllMetrics'
]

