
$CommandsToComplete = [System.Collections.Generic.List[string]]::new()
# Get-ChildItem $PSScriptRoot/Class/*.psm1  | ForEach-Object {Import-Module $_.FullName}
Get-ChildItem $PSScriptRoot/Class/*.psm1  | ForEach-Object {Get-Content $_.FullName -Raw | Invoke-Expression}
Get-ChildItem $PSScriptRoot/Private/*.ps1 | ForEach-Object {. $_.FullName}
Get-ChildItem $PSScriptRoot/Public/*.ps1  | ForEach-Object {. $_.FullName; $CommandsToComplete.Add($_.BaseName)}


$Script:Config = Import-Configuration


# There really needs to be an enum for Verbose, Debug, ErrorAction etc
$Script:COMMON_PARAMETERS = [System.Collections.Generic.HashSet[string]]::new()
$CommonParamClasses = (
    [Management.Automation.Internal.CommonParameters],
    [Management.Automation.Internal.ShouldProcessParameters],
    [Management.Automation.Internal.TransactionParameters]
)
$CommonParamClasses |
    ForEach-Object {$_.GetProperties()} |
    Select-Object -ExpandProperty Name |
    ForEach-Object {$COMMON_PARAMETERS.Add($_)} |
    Out-Null


$CompleterSplat = @{
    CommandName   = $CommandsToComplete
    ParameterName = 'Server'
    ScriptBlock   = {
        param ($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
        return @($Config.Contexts.Keys) -like "*$WordToComplete*"
    }
}
Register-ArgumentCompleter @CompleterSplat
