function Get-WildFireReport {
    <#
    .SYNOPSIS
    Get the report from WildFire API

    .DESCRIPTION
    Get the report from WildFire API

    .PARAMETER Hash
    Hash of the File

    .PARAMETER File
    File information pointing on the uploaded file

    .PARAMETER Wait
    Wait for result if analysis is pending

    .PARAMETER TimeOut
    Timeout (in s) before stop waiting

    .PARAMETER Interval
    Interval between each attempts

    .EXAMPLE

    .NOTES

    #>
    [CmdletBinding(DefaultParameterSetName = 'none')]
    Param(
        [Parameter(Mandatory, ParameterSetName = "Hash", ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string] $Hash,
        [Parameter(ParameterSetName = "FileInformation", ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [System.IO.FileInfo] $File,
        [Parameter(ParameterSetName = "FilePath", ValueFromPipelineByPropertyName)]
        [string] $Path,
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [switch] $Wait,
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [int] $TimeOut = 1800,
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [int] $interval = 30
    )
    Begin {
        Test-WildfireConnection
        $start = Get-Date
        Enum WildFireResults
        {
            Benign = 0
            Malware = 1
            Grayware = 2
            Phishing = 4
            C2 = 5
            Pending = -100
            Error = -101
            NotFound = -102
            Invalid = -103
        }
    }
    Process {
        if ($PSCmdlet.ParameterSetName -eq 'FileInformation') {
            Try {
                $hash = Get-FileHash -LiteralPath $File.FullName | Select-Object -ExpandProperty Hash
            } Catch {
                Throw "Error during access to the file $($file.FullName) $_"
            }
        }
        if ($PSCmdlet.ParameterSetName -eq 'FilePath') {
            Try {
                $hash = Get-FileHash -LiteralPath $Path | Select-Object -ExpandProperty Hash
            } Catch {
                Throw "Error during access to the file $($path) $_"
            }
        }
        $fieldsReport = @{
            apikey=$(New-Object PSCredential 0, $_ApiKey).GetNetworkCredential().Password;
            hash=$hash
        }
        Try {
            $params = @{
                Method      = "POST"
                Uri         = $_VerdictURL
                Headers     = @{"Accept"="application/json"}
                Body        = $fieldsReport
            }
            Do {
                Write-Verbose "Request report for $hash"
                Write-Verbose "Request report for $($fieldsReport | ConvertTo-Json)"
                $WebResponse = Invoke-WebRequest @params
                Try {
                    Write-Verbose "Response $($WebResponse.Content)"
                    $response = $([xml]$WebResponse.Content).wildfire

                    if ($response.'get-verdict-info') {
                        if ($Wait -eq $true -and [int]$response.'get-verdict-info'.verdict -eq [WildFireResults]::Pending -and ($($(get-date) - $start).TotalSeconds -lt $Timeout)) {
                            Write-Verbose "Report still not ready $($response.'get-verdict-info'.verdict). Waiting ${interval}/${TimeOut}s"
                            Start-Sleep $interval
                            $continue = $true
                        } else {
                            $continue = $false
                            $PSObject = New-Object PSObject
                            $response.'get-verdict-info'.ChildNodes | ForEach-Object {
                                $PSObject | Add-Member NoteProperty $_.Name $_.'#text'
                            }
                            $PSObject | Add-Member NoteProperty "Result" $([WildFireResults]$response.'get-verdict-info'.verdict) -Force
                            $PSObject
                        }                      
                    } else {
                        throw "Unknown problem result retrieval $($WebResponse.Content)"                     
                    }
                } Catch {
                    throw "Can't parse content $($WebResponse.Content)"
                }
            } While ($continue)
        } Catch {
            Write-Verbose "Response $($WebResponse.Content)"
            $details = $_.Exception
            Switch ($details.Response.StatusCode) {
                418 { #Unsupported file type
                    throw $details.Response.StatusDescription
                }
                419 { #Too many request
                    throw $details.Response.StatusDescription
                }
                421 { #Invalid Hash
                    throw $details.Response.StatusDescription
                }
                default {
                    Write-Verbose "Unknown Status code : $($details.Response.StatusCode)"
                    throw $details
                }
            }
        }
    }
}

