function Set-Context
{
    [CmdletBinding()]
    param ()


    $Caller       = (Get-PSCallStack)[1]
    $CallerParams = $Caller.InvocationInfo.BoundParameters
    $Server       = $CallerParams.Server
    $Token        = $CallerParams.Token

    if (-not $Script:Config)
    {
        $Script:Config = Import-Configuration
    }

    $HashCode = ($Config | ConvertTo-Json -Compress).GetHashCode()
    $Context  = $null


    # Normalise URI
    if ($Server)
    {
        $Server = [uri]($Server -replace '/$')

        # default to https
        if (-not $Server.Scheme)
        {
            $Server = [uri]"https://$Server"
        }

        # strip default port numbers
        if ($Server.Authority -match ':' -and $Server.IsDefaultPort)
        {
            $Server = [uri]"$($Server.Scheme)://$($Server.Host)$($Server.LocalPath)"
        }
    }


    if ($Server -and $Config.CurrentContext -ne $Server.Authority)
    {
        $Config.CurrentContext = $Server.Authority
    }


    $Context = $Config.Contexts[$Config.CurrentContext]
    if (-not $Context)
    {
        $Context = @{Server = $Server}
        $Config.Contexts[$Server.Authority] = $Context
    }


    if ($Token)
    {
        $Context.Token = $Token
    }


    if ($HashCode -ne ($Config | ConvertTo-Json -Compress).GetHashCode())
    {
        Export-Configuration $Config
    }
}
