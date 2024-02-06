function ConvertTo-WildfireBody {
    <#
    .SYNOPSIS
    Converts file to memory stream to create body for Invoke-RestMethod and send it to Wildfire API.

    .DESCRIPTION
    Converts file to memory stream to create body for Invoke-RestMethod and send it to Wildfire API.

    .PARAMETER FileInformation
    Path to a file to send to Wildfire API

    .PARAMETER Boundary
    Boundary information to say where the file starts and ends.

    .EXAMPLE
    $Boundary = [Guid]::NewGuid().ToString()
    ConvertTo-WildfireAPI -File $File -Boundary $Boundary

    .NOTES
    Inspired by https://github.com/EvotecIT/VirusTotalAnalyzer/blob/master/Private/ConvertTo-VTBody.ps1

    #>
    [cmdletBinding()]
    param(
        [parameter(Mandatory)][System.IO.FileInfo] $FileInformation,
        [parameter(Mandatory)][string] $Boundary
    )
    [byte[]] $CRLF = 13, 10 # ASCII code for CRLF
    $BoundaryInformation = [System.Text.Encoding]::Default.GetBytes("--$Boundary")
    $MemoryStream = [System.IO.MemoryStream]::new()
    $MemoryStream.Write($BoundaryInformation, 0, $BoundaryInformation.Length)
    $MemoryStream.Write($CRLF, 0, $CRLF.Length)

    # Api Key
    $ApiData = [System.Text.Encoding]::Default.GetBytes("Content-Disposition: form-data; name=`"apikey`"")
    $MemoryStream.Write($ApiData, 0, $ApiData.Length)
    $MemoryStream.Write($CRLF, 0, $CRLF.Length)
    $MemoryStream.Write($CRLF, 0, $CRLF.Length)
    $MemoryStream.Write([System.Text.Encoding]::Default.GetBytes((New-Object PSCredential 0, $_ApiKey).GetNetworkCredential().Password), 0, [System.Text.Encoding]::Default.GetBytes((New-Object PSCredential 0, $_ApiKey).GetNetworkCredential().Password).Length)
    $MemoryStream.Write($CRLF, 0, $CRLF.Length)
    
    # File
    $MemoryStream.Write($BoundaryInformation, 0, $BoundaryInformation.Length)
    $MemoryStream.Write($CRLF, 0, $CRLF.Length)
    $FileData = [System.Text.Encoding]::Default.GetBytes("Content-Disposition: form-data; name=`"file`"; filename=""$($FileInformation.Name)""")
    $MemoryStream.Write($FileData, 0, $FileData.Length)
    $MemoryStream.Write($CRLF, 0, $CRLF.Length)
    $ContentType = [System.Text.Encoding]::Default.GetBytes('Content-Type:application/octet-stream')
    $MemoryStream.Write($ContentType, 0, $ContentType.Length)
    $MemoryStream.Write($CRLF, 0, $CRLF.Length)
    $MemoryStream.Write($CRLF, 0, $CRLF.Length)
    $FileContent = ([System.IO.File]::ReadAllBytes($FileInformation.FullName))
    $MemoryStream.Write($FileContent, 0, $FileContent.Length)
    $MemoryStream.Write($CRLF, 0, $CRLF.Length)

    # Closure
    $MemoryStream.Write($BoundaryInformation, 0, $BoundaryInformation.Length)
    $Closure = [System.Text.Encoding]::Default.GetBytes('--')
    $MemoryStream.Write($Closure, 0, $Closure.Length)
    $MemoryStream.Write($CRLF, 0, $CRLF.Length)
   
    , $MemoryStream.ToArray()
}