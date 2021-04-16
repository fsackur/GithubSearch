
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
            throw [Management.Automation.ParameterBindingException]::new(
                "You cannot use 'User' and 'Org' together."
            )
        }

        if ($Repo -and $Repo -notmatch '/')
        {
            if ($User -or $Org)
            {
                # We've already validated that we don't have both User and Org
                $Repo = "$User$Org/$Repo"
            }
            else
            {
                throw [Management.Automation.ParameterBindingException]::new(
                    "The 'Repo' parameter requires qualification. Either provide a value in the format 'fsackur/GithubSearch' or supply a value to the 'User' or 'Org' parameter."
                )
            }
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
