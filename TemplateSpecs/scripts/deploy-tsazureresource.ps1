$getTemplateSpecParameters = @{
    Name = 'resourcegroup'
    ResourceGroupName = 'rg-mytemplatespecs'
    Version = '0.1'

}
#get the Azure Template Spec resource Id with Splatting
$templateSpecResource = Get-AzTemplateSpec @getTemplateSpecParameters

# contains the bicep parameters to deploy the resource group
$templateParameters = @{
    resourceGroupName = 'rg-newrgts'
    location = 'westeurope'
    tags = @{'ownedBy' = 'Joe Tahsin'}
}

# deploy the TS Template - ResourceGroup 
$DeploymentParameters = @{
    Location = 'westeurope'
    TemplateParameterObject = $templateParameters
    TemplateSpecId = $templateSpecResource.Id
}
#deployment command azure deployment with Splatting
New-AzSubscriptionDeployment @DeploymentParameters
