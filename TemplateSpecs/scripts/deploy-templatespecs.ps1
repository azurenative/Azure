#1. create resource group
$tsRgParameters = @{
    resourceGroupName = "rg-mytemplatespecs"
    location = "westeurope"
}

New-AzResourceGroup @tsRgParameters -Verbose
#2. deploy ts template to azure.
$tsParameters = @{
    Name = "resourcegroup"
    ResourceGroupName = "rg-mytemplatespecs"
    TemplateFile = ".\specs\resourcegroup\resourcegroup.bicep"
    Version = "0.1"
    Location = 'westeurope'
}

New-AzTemplateSpec @tsParameters


Set-AzTemplateSpec @tsParameters