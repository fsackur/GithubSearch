
# Get-ChildItem $PSScriptRoot/Class/*.psm1  | ForEach-Object {Import-Module $_.FullName}
Get-ChildItem $PSScriptRoot/Class/*.psm1  | ForEach-Object {Get-Content $_.FullName -Raw | Invoke-Expression}
Get-ChildItem $PSScriptRoot/Private/*.ps1 | ForEach-Object {. $_.FullName}
Get-ChildItem $PSScriptRoot/Public/*.ps1  | ForEach-Object {. $_.FullName}
