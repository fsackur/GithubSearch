function Get-ContextParameters
{
    if ($Script:CONTEXT_PARAMETERS)
    {
        return $Script:CONTEXT_PARAMETERS
    }


    $Script:CONTEXT_PARAMETERS = [Management.Automation.RuntimeDefinedParameterDictionary]::new()


    $ParamAttribute = [Parameter]::new()
    $ServerAttributes = [Collections.ObjectModel.Collection[Attribute]]::new()
    $ServerAttributes.Add($ParamAttribute)
    $ServerParam = [Management.Automation.RuntimeDefinedParameter]::new('Server', [uri], $ServerAttributes)


    $ParamAttribute = [Parameter]::new()
    $TokenValidator = [ValidateScript]::new({
        if ($_.GetType() -notin ([string], [securestring], [scriptblock]))
        {
            throw "Token must be a String, SecureString, or a scriptblock that provides a String or SecureString."
        }
        return $true
    })
    $TokenAttributes = [Collections.ObjectModel.Collection[Attribute]]::new()
    $TokenAttributes.Add($ParamAttribute)
    $TokenAttributes.Add($TokenValidator)
    $TokenParam = [Management.Automation.RuntimeDefinedParameter]::new('Token', [object], $TokenAttributes)


    $CONTEXT_PARAMETERS.Add('Server', $ServerParam)
    $CONTEXT_PARAMETERS.Add('Token', $TokenParam)
    $CONTEXT_PARAMETERS
}
