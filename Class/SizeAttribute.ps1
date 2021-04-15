
class SizeAttribute : Management.Automation.ArgumentTransformationAttribute
{
    [object] Transform([Management.Automation.EngineIntrinsics]$engineIntrinsics, [object]$Value)
    {
        if ([string]::IsNullOrEmpty($Value))
        {
            return $Value
        }

        if ($Value -is [System.Collections.IList])
        {
            $Values = $Value[0, -1]
        }
        if ($Value -match '.\.\..')
        {
            $Values = $Value -split '\.\.'
        }
        else
        {
            $Values = $Value
        }

        $Values = $Values | ForEach-Object {
            $Operator, $Size = $_ -split '(?=\d+)', 2
            if ($Size -match '^\s*(\d+)\s*(MB|GB)?$')
            {
                $Size, $Suffix = $Matches[1, 2]
                $Size = [double]$Size * "1$Suffix"
                $Size = [Math]::Truncate($Size)
            }
            else
            {
                throw [Management.Automation.ParameterBindingException]::new(
                    "Value '$Value' is not a valid size. Provide a numeric value with an optional MB or GB suffix."
                )
            }

            $Operator = $Operator.Trim()
            if ($Operator -notin ('', '>', '>=', '<', '<='))
            {
                throw [Management.Automation.ParameterBindingException]::new(
                    "Operator '$Operator' is invalid. Valid values are: '>', '>=', '<', '<='."
                )
            }

            $Operator, $Size -join ''
        }

        return $Values -join '..'
    }
}
