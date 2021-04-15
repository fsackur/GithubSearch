
function Find-GithubCode
{
    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromRemainingArguments)]  #Position = 0,
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

        [string]$Size
    )

    if (-not $COMMON_PARAMETERS)
    {
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
    }

    if ($User -and $Org)
    {
        throw
    }

    if ($Repo -and $Repo -notmatch '/' -and -not ($User -or $Org))
    {
        # throw
    }

    $SearchTerms = [ordered]@{}
    $Params = $MyInvocation.MyCommand.Parameters.Values | Where-Object {$_.Name -notin $COMMON_PARAMETERS}
    foreach ($Param in $Params)
    {
        $Name      = $Param.Name
        $Value     = Get-Variable $Name -ValueOnly -ErrorAction SilentlyContinue
        if (-not $Value)
        {
            continue
        }

        $Param.Attributes.ValidatePattern
        # if ($Param.Attributes.ValidatePattern)
        # $Qualifier = $Name.ToLower()
        # $Qualifier
    }
}
<#
in:file	octocat in:file matches code where "octocat" appears in the file contents.
in:path	octocat in:path matches code where "octocat" appears in the file path.

user:USERNAME	user:defunkt extension:rb matches code from @defunkt that ends in .rb.
org:ORGNAME	org:github extension:js matches code from GitHub that ends in .js.
repo:USERNAME/REPOSITORY	repo:mozilla/shumway extension:as matches code from @mozilla's shumway project that ends in .as.

path:/	octocat filename:readme path:/ matches readme files with the word "octocat" that are located at the root level of a repository.
path:DIRECTORY	form path:cgi-bin language:perl matches Perl files with the word "form" in a cgi-bin directory, or in any of its subdirectories.
path:PATH/TO/DIRECTORY	console path:app/public language:javascript matches JavaScript files with the word "console" in an app/public directory, or in any of its subdirectories (even if they reside in app/public/js/form-validators).

language:LANGUAGE


size:n	function size:>10000 language:python matches code with the word "function," written in Python, in files that are larger than 10 KB.
    greater than, less than, and range qualifiers

filename:FILENAME	filename:linguist matches files named "linguist."
filename:.vimrc commands matches .vimrc files with the word "commands."
filename:test_helper path:test language:ruby matches Ruby files named test_helper within the test directory.

extension:EXTENSION	form path:cgi-bin extension:pm matches code with the word "form," under cgi-bin, with the .pm file extension.
icon size:>200000 extension:css matches files larger than 200 KB that end in .css and have the word "icon."
#>
