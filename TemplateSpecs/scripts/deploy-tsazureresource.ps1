$getTemplateSpecParameters = @{
    Name              = 'resourcegroup'
    ResourceGroupName = 'rg-mytemplatespecs'
}
#get the Azure Template Spec resource Id with Splatting
$templateSpecResource = Get-AzTemplateSpec @getTemplateSpecParameters
$templateSpecVersionResourceId = $templateSpecResource.Versions | Select-Object -Last 1 -ExpandProperty Id

# contains the bicep parameters to deploy the resource group
$templateParameters = @{
    resourceGroupName = 'rg-newrgts'
    location          = 'westeurope'
    tags              = @{'ownedBy' = 'Joe Tahsin' }
}

# deploy the TS Template - ResourceGroup 
$DeploymentParameters = @{
    Location                = 'westeurope'
    TemplateParameterObject = $templateParameters
    TemplateSpecId          = $templateSpecVersionResourceId
}
#deployment command azure deployment with Splatting
New-AzSubscriptionDeployment @DeploymentParameters