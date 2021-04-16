
class SizeAttribute : Management.Automation.ArgumentTransformationAttribute
{
    [object] Transform([Management.Automation.EngineIntrinsics]$engineIntrinsics, [object]$Value)
    {
        if ([string]::IsNullOrEmpty($Value))
        {
            return $Value
        }

        $Value = $Value | ForEach-Object {$_.Trim()}
        $Value = $Value -join '..'

        $OperatorPattern = '^', '(?<Operator>>|>=|<|<=)?', '(?<Size>\d+)', '(?<Multiplier>MB|GB)?', '$' -join '\s*'
        $RangePattern = '^', '(?<Size1>\d+)', '(?<Multiplier1>MB|GB)?', '\.\.', '(?<Size1>\d+)', '(?<Multiplier2>MB|GB)?', '$' -join '\s*'

        if ($Value -match $OperatorPattern)
        {
            $Operator, $Size, $Multiplier = $Matches.Operator, $Matches.Size
            $Size = [double]$Matches.Size * "1$($Matches.Multiplier)"
            $Size = [Math]::Truncate($Size)

            return $Operator, $Size -join ''

        }
        elseif ($Value -match $RangePattern)
        {
            $Size1 = [double]$Matches.Size1 * "1$($Matches.Multiplier1)"
            $Size1 = [Math]::Truncate($Size1)

            $Size2 = [double]$Matches.Size2 * "1$($Matches.Multiplier2)"
            $Size2 = [Math]::Truncate($Size2)

            return $Size1, $Size2 -join '..'

        }
        else
        {
            throw [Management.Automation.ParameterBindingException]::new(
                "Value '$Value' is not a valid size argument. Provide a value in one of these " +
                "formats: '>n', '>=n', '<n', '<=n', 'n..n', where 'n' can include a 'MB' or 'GB' " +
                "suffix."
            )
        }
    }
}
