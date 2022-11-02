#region example 1 step by step deploy a single resource template spec

$getTemplateSpecParameters = @{
    Name              = 'resourcegroup'
    ResourceGroupName = 'rg-templatespecs'
}
#get the Azure Template Spec resource Id with Splatting
$templateSpecResource = Get-AzTemplateSpec @getTemplateSpecParameters
$templateSpecVersionResourceId = $templateSpecResource.Versions | Select-Object -Last 1 -ExpandProperty Id

# contains the bicep parameters to deploy the resource group
$templateParameters = @{
    resourceGroupName = 'rg-templatespecs'
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
#endregion

#region example 2 deploy main template with template spec modules

$DeploymentParameters = @{
    Name = "mytemplatespecmoduledeployment"
    Location = "westeurope"
    TemplateFile = ".\modules\main.bicep"
}

#deployment command azure deployment with Splatting
New-AzSubscriptionDeployment @DeploymentParameters
#endregion