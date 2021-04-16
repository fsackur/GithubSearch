function Invoke-GithubMethod
{
    <#
        .SYNOPSIS
        A wrapper for Invoke-RestMethod.

        .NOTES
        Largely generated with MetaProgramming: see PSGallery
    #>
    [CmdletBinding()]
    param
    (
        [Microsoft.PowerShell.Commands.WebRequestMethod]
        ${Method},

        [switch]
        ${UseBasicParsing},

        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [uri]
        ${Uri},

        [Microsoft.PowerShell.Commands.WebRequestSession]
        ${WebSession},

        [Alias('SV')]
        [string]
        ${SessionVariable},

        [pscredential]
        [System.Management.Automation.CredentialAttribute()]
        ${Credential},

        [switch]
        ${UseDefaultCredentials},

        [ValidateNotNullOrEmpty()]
        [string]
        ${CertificateThumbprint},

        [ValidateNotNull()]
        [X509Certificate]
        ${Certificate},

        [string]
        ${UserAgent},

        [switch]
        ${DisableKeepAlive},

        [ValidateRange(0, 2147483647)]
        [int]
        ${TimeoutSec},

        [System.Collections.IDictionary]
        ${Headers},

        [ValidateRange(0, 2147483647)]
        [int]
        ${MaximumRedirection},

        [uri]
        ${Proxy},

        [pscredential]
        [System.Management.Automation.CredentialAttribute()]
        ${ProxyCredential},

        [switch]
        ${ProxyUseDefaultCredentials},

        [Parameter(ValueFromPipeline = $true)]
        [object]
        ${Body},

        [string]
        ${ContentType},

        [ValidateSet('chunked', 'compress', 'deflate', 'gzip', 'identity')]
        [string]
        ${TransferEncoding},

        [string]
        ${InFile},

        [string]
        ${OutFile},

        [switch]
        ${PassThru},

        [object]
        $Token      # Not in PSv5
    )

    begin
    {
        #region Inject module defaults
        if (-not $ContentType)
        {
            $PSBoundParameters.ContentType = 'application/vnd.github.v3+json'
        }

        if (-not $Uri.IsAbsoluteUri)
        {
            $Uri = $Uri -replace '^/'
            $Server = Get-Context -Server
            $PSBoundParameters.Uri = [uri]($Server, $Uri -join '/')
        }

        if (-not ($Token -or $Headers.Authorization))
        {
            $Token = Get-Context -Token
        }

        if ($Token)
        {
            if ($Token -is [securestring])
            {
                $Token = $Token | ConvertTo-Plaintext
            }

            if (-not $Headers)
            {
                $PSBoundParameters.Headers = $Headers = @{}
            }
            $Headers.Authorization = "token $Token"
            [void]$PSBoundParameters.Remove('Token')
        }
        #endregion Inject module defaults
    }

    end
    {
        if ($MyInvocation.ExpectingInput)
        {
            [object[]]$Body = $input
        }

        $Body | Invoke-RestMethod @PSBoundParameters
    }
}
