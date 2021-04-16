function Get-Context
{
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param
    (
        [Parameter(ParameterSetName = 'Server')]
        [switch]$Server,

        [Parameter(ParameterSetName = 'Token')]
        [switch]$Token
    )


    if (-not $Script:Config)
    {
        $Script:Config = Import-Configuration
    }
    $Context = $Config.Contexts[$Config.CurrentContext]


    $ParamSet = $PSCmdlet.ParameterSetName
    if ($ParamSet -eq 'Default')
    {
        return $Context
    }

    $Value = $Context.$ParamSet
    if ($Value -is [scriptblock])
    {
        return & $Value
    }
    return $Value
}
