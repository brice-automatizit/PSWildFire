function Test-WildfireConnection {
    <#
    .SYNOPSIS

    Check current Wildfire Connexion.

    .DESCRIPTION

    Check if variables are present (ie. The Connect-WildFire has been launched)

    .EXAMPLE

    PS>Test-WildfireConnection
        
    .INPUTS
        
    none

    .OUTPUTS
        
    void
    #>
    [CmdletBinding()]
    Param ()
    Begin {
    }
    Process {
        If (-not ($_ApiKey -and $_VerdictURL -and $_SubmitFileURL)) {
            throw 'Please run Connect-WildFire before'
        }
    }
    End {
    }
}