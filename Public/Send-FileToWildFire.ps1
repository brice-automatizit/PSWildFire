function Send-FileToWildFire {
    <#
    .SYNOPSIS
    Send file to WildFire

    .DESCRIPTION
    

    .PARAMETER FilePath
    Provide FilePath to a file to check.

    .PARAMETER FileInformation
    Provide FileInformation to a file to check.

    .EXAMPLE
    

    .NOTES
    
    #>
    [CmdletBinding(DefaultParameterSetName = 'FileInformation')]
    Param(
        [Parameter(Mandatory, ParameterSetName = 'FileInformation', ValueFromPipeline, Position = 0)]
        [System.IO.FileInfo]
        $FileInformation,
        [Parameter(Mandatory, ParameterSetName = 'FilePath', ValueFromPipeline, Position = 0)]
        [string]
        $FilePath,
        [Parameter()]
        [switch] $AsZip
    )
    Begin {
        Test-WildfireConnection
        $listFiles = [System.Collections.ArrayList]@()
        $results = [System.Collections.ArrayList]@()
    }
    Process {
        if ($FilePath) {
            Write-Verbose "Path received" 
            Try {
                $FileInformation = Get-Item $FilePath
            } Catch {
                throw "Can't get file at $FilePath"
            }
        }
        if ($FileInformation) {
            Write-Verbose "File Information received $($FileInformation.GetType())"
            $listFiles.Add($FileInformation) | Out-Null
        }
    }
    End {

        if ($AsZip) {
            $archiveName = "$([guid]::NewGuid() | Select-Object -ExpandProperty Guid).zip"
            Write-Verbose "Adding  as $archiveName"
            $compressArguments = @{
                LiteralPath = $listFiles | Select-Object -ExpandProperty FullName
                CompressionLevel = "NoCompression"
                DestinationPath = $(Join-Path $($env:temp) $archiveName)
            }
            $ProgressPreference = 'silentlycontinue'
            Compress-Archive @compressArguments
            $listFiles = Get-Item $compressArguments.DestinationPath
        }


        foreach ($file in $listFiles) {
            Write-Verbose "Sending file $($file.FullName)"
            
            Try {
                $FileHash = Get-FileHash -LiteralPath $file.FullName
            } Catch {
                throw "Can't access to specified file $($file.FullName)"
            }

            $Boundary = [Guid]::NewGuid().ToString()

            Try {
                $params = @{
                    Method      = "POST"
                    Uri         = $_SubmitFileURL
                    ContentType = "multipart/form-data; boundary=`"$boundary`""
                    Headers     = @{"Accept"="application/json"}
                    Body        = $(ConvertTo-WildfireBody -FileInformation $file -Boundary $Boundary)
                }

                if ($AsZip) {
                    Write-Verbose "Remove item $($file.fullName)"
                    Remove-Item $file | Out-Null
                }

                $WebResponse = Invoke-WebRequest @params
                Try {
                    $response = $([xml]$WebResponse.Content).wildfire
                    if ($response.'upload-file-info'.sha256 -eq $fileHash.Hash) {
                        Write-Verbose "File successfully uploaded through hash $($response.'upload-file-info'.sha256)"
                        $PSObject = New-Object PSObject
                        $response.'upload-file-info'.ChildNodes | ForEach-Object {
                            $PSObject | Add-Member NoteProperty $_.Name $_.'#text'
                        }
                        $results.Add($PSObject) | Out-Null
                    } else {
                        throw "Unknown problem during upload $($WebResponse.Content)"                     
                    }
                } Catch {
                    throw "Can't parse content $($WebResponse.Content)"
                }
            } Catch {
                $details = $_.Exception
                Switch ($details.Response.StatusCode) {
                    418 { #Unsupported file type
                        throw $details.Response.StatusDescription
                    }
                    419 { #Too many request
                        throw $details.Response.StatusDescription
                    }
                    default {
                        throw $details
                    }
                }
            }
        }

        Write-Verbose "Return $($results.Count)"
        $results

    }
}

