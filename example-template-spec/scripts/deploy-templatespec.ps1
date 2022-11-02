# example script will deploy all bicep templates as template spec.
Function Deploy-TemplateSpec {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $bicepModulesPath,

        [Parameter()]
        [string]$resourceGroupName
    )
    $templateSpecModules = Get-ChildItem -Path $bicepModulesPath -Filter *.bicep -Recurse -Exclude 'main.bicep'
    $templateSpecModules | ForEach-Object {
        $tsParameters = @{
            Name = $_.BaseName
            ResourceGroupName = $resourceGroupName
            TemplateFile = $_
            Version = "0.1"
            Location = 'westeurope'
        }    
        New-AzTemplateSpec @tsParameters
    }
}

Deploy-TemplateSpec -ResourceGroupName "rg-mytemplatespecs" -bicepModulesPath ".\modules" -Verbose