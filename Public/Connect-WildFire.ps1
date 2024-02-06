function Connect-Wildfire {
    <#
    .SYNOPSIS

    Set internal variables for connexion.

    .DESCRIPTION

    Set internal variables for connexion.

    .PARAMETER ApiKey

    System.Security.SecureString
    This is the api key of wildfire service

    .PARAMETER ApiKeyPlainText

    string
    This is the api key of wildfire service in plain-text

    .EXAMPLE

    PS>Connect-Wildfire -ApiKey "xxx"
        
    .INPUTS
        
    System.Security.SecureString

    .OUTPUTS
        
    boolean
    #>
    [CmdletBinding(DefaultParameterSetName = 'none')]
    Param (
        [Parameter(Mandatory, HelpMessage = 'ApiKey SecureString', ParameterSetName = 'ApiKey', ValueFromPipeline, Position = 0)]
        [System.Security.SecureString]
        $ApiKey,
        [Parameter(Mandatory, HelpMessage = 'ApiKey in Plain Text', ParameterSetName = 'ApiKeyPlainText', ValueFromPipeline, Position = 0)]
        [string]
        $ApiKeyPlainText,
        [Parameter(HelpMessage = 'URL Verdict', ParameterSetName = 'VerdictURL', ValueFromPipeline, Position = 1)]
        [System.Uri]
        $VerdictURL = "https://wildfire.paloaltonetworks.com/publicapi/get/verdict",
        [Parameter(HelpMessage = 'URL For Submit', ParameterSetName = 'SubmitFileURL', ValueFromPipeline, Position = 2)]
        [System.Uri]
        $SubmitFileURL = "https://wildfire.paloaltonetworks.com/publicapi/submit/file"
    )
    Begin {
        # Remove any module-scope variables in case the user is reauthenticating
        Remove-Variable -Scope Script -Name _ApiKey, _VerdictURL, _SubmitFileURL  -Force -ErrorAction SilentlyContinue | Out-Null
        Set-Variable -Name _VerdictURL -Value $VerdictURL -Option ReadOnly -Scope Script -Force  | Out-Null
        Set-Variable -Name _SubmitFileURL -Value $SubmitFileURL -Option ReadOnly -Scope Script -Force  | Out-Null
        $keyIsValid = $false
    }
    Process {
        if (-not $ApiKey) {
            if (-not $ApiKeyPlainText) {
                $ApiKey = Read-Host -AsSecureString "Please enter your WildFire API Key"
            } else {
                $ApiKey = $ApiKeyPlainText | ConvertTo-SecureString -AsPlainText  -Force
                Remove-Variable -Name ApiKeyPlainText -Force
            }
        } else {
            Write-Verbose "Getting $ApiKey"
        }

        if ($ApiKey) {
            Set-Variable -Name _ApiKey -Value $ApiKey -Option ReadOnly -Scope Script -Force  | Out-Null
            $hash = $((1..64 | ForEach-Object { '{0:X}' -f 0 }) -join "")
            Get-WildfireReport -hash $hash | Out-Null
            $keyIsValid = $true
        }
    }
    End {
        if ($keyIsValid -eq $false) {
            Remove-Variable -Scope Script -Name _ApiKey, _VerdictURL, _SubmitFileURL  -Force -ErrorAction SilentlyContinue | Out-Null
            throw "Key appears invalid"
        } else {
            Write-Verbose "Authenticated to Wildfire"
        }
    }
}