# example script will deploy all bicep templates as template spec.
[CmdletBinding()]
param (
    [Parameter()]
    [string]$ResourceGroupName
)
$templateSpecModules = Get-ChildItem -Path .\modules -Filter *.bicep -Recurse -Exclude 'main.bicep'
$templateSpecModules | ForEach-Object {
    $tsParameters = @{
        Name = $_.BaseName
        ResourceGroupName = $ResourceGroupName
        TemplateFile = $_
        Version = "0.1"
        Location = 'westeurope'
    }    
    New-AzTemplateSpec @tsParameters
}


