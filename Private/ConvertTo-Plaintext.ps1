
function ConvertTo-Plaintext
{
    <#
        .SYNOPSIS
        Converts a SecureString to a plaintext string

        .DESCRIPTION
        Converts a SecureString to a plaintext string

        .PARAMETER SecureString
        The SecureString to convert to plaintext

        .OUTPUTS
        [String]

        .EXAMPLE
        $Password = ConvertTo-SecureString "hunter2" -AsPlainText -Force
        ConvertTo-Plaintext -SecureString $Password

        Returns the plaintext string from a SecureString
        #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [System.Security.SecureString]$SecureString
    )

    # This approach copied from Utils.cs in Microsoft.PowerShell.SecretStore
    try
    {
        $Pointer = [Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($SecureString)
        $Bytes = [Byte[]]::new($SecureString.Length * 2)
        [Runtime.InteropServices.Marshal]::Copy($Pointer, $Bytes, 0, $Bytes.Length)
        [Text.Encoding]::Unicode.GetString($Bytes)
    }
    finally
    {
        #This is important, it zeroes out the memory
        [Runtime.InteropServices.Marshal]::ZeroFreeCoTaskMemUnicode($Pointer)
    }
}
