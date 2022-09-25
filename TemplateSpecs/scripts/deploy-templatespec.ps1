$tsParameters = @{
    Name = "resourcegroup"
    ResourceGroupName = "rg-mytemplatespecs"
    TemplateFile = ".\specs\resourcegroup\resourcegroup.bicep"
    Version = "0.1"
    Location = 'westeurope'
}

New-AzTemplateSpec @tsParameters