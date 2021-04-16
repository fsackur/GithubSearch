
# using module @{ModuleName = 'SizeAttribute'; MaximumVersion = '9.9.9.9'}

function Find-GithubCode
{
    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromRemainingArguments)]
        [string[]]$Keyword,

        [Parameter()]
        [ValidateSet('File', 'Path', 'FileAndPath')]
        [string]$In,

        [string]$User,
        [string]$Org,
        [string]$Repo,

        [string]$Path,
        [string]$Extension,
        [string]$Filename,

        [string]$Language,

        [SizeAttribute()]
        [string]$Size
    )


    dynamicparam
    {
        Get-ContextParameters
    }

    begin
    {
        Set-Context
    }

    end
    {
        if ($User -and $Org)
        {
            throw
        }

        if ($Repo -and $Repo -notmatch '/' -and -not ($User -or $Org))
        {
            # throw
        }


        $Params = $MyInvocation.MyCommand.Parameters.Values | Where-Object {$_.Name -notin $COMMON_PARAMETERS}

        $SearchTerms = [Collections.Generic.List[string]]::new()
        foreach ($Param in $Params)
        {
            $Name  = $Param.Name
            $Value = Get-Variable $Name -ValueOnly -ErrorAction SilentlyContinue

            if ($Name -eq 'Keyword')
            {
                $SearchTerms.AddRange($Value)
            }
            elseif ($Value)
            {
                $Term = "{0}:{1}" -f $Name.ToLower(), $Value
                $SearchTerms.Add($Term)
            }
        }

        $Uri = "/search/code?q=$($SearchTerms -join '+')"
        Invoke-GithubMethod $Uri
    }
}
