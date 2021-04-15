function Use-GithubToken
{
    <#
        .SYNOPSIS
        Sets token for queries. Set to null to query without authentication.

        .NOTES
        Will probably be removed. Not an elegant solution.
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [AllowNull()]
        [securestring]$Token
    )

    if (-not $Script:PSDefaultParameterValues)
    {
        $Script:PSDefaultParameterValues = @{}
    }
    $Script:GITHUB_TOKEN = $Token
    $Script:PSDefaultParameterValues['Invoke-GithubMethod:Token'] = {$Script:GITHUB_TOKEN}
}
