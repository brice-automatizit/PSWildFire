# PSWildFire

[![PowerShell Gallery][psgallery-badge]][psgallery]

A PowerShell module for interfacing with the Palo Alto WildFire API.

## Usage

### Install

```PowerShell
PS> Install-Module PSWildFire
```

### Import

```PowerShell
PS> Import-Module PSWildFire
```

### Connect

```PowerShell
PS> Connect-Wildfire -ApiKeyPlainText "xxx"
```

* Specify the ```-VerdictURL``` value to change your wildfire VerdictURL (default to "https://wildfire.paloaltonetworks.com/publicapi/get/verdict").
* Specify the ```-SubmitFileURL``` value to change your wildfire SubmitFileURL (default to "https://wildfire.paloaltonetworks.com/publicapi/submit/file").

### Example for unattended

```PowerShell
PS> # Save credentials
PS> Get-Credential -UserName "dummy" -Message "Enter Wildfire API Key" | Export-Clixml "$($ENV:USERPROFILE)\pswildfire.xml"
PS> # Use those save credentials (same computer, same windows session)
PS> Import-Clixml "$($ENV:USERPROFILE)\pswildfire.xml" | Select-Object -ExpandProperty Password | Connect-Wildfire -Verbose
```

### Submit a file

```PowerShell
PS> $upload = Send-FileToWildFire "C:\tmp\mysuspiciousfile.docx"
```

Through pipeline:

```PowerShell
PS> "C:\tmp\mysuspiciousfile.docx" | Send-FileToWildFire
url      :
filename : mysuspiciousfile.docx
sha256   : aff65f0275e76eac3c9e3468d0d6e4cf78a0853c67c9dd4d1470afc104f952e9
md5      : c3b07ec4f09a412a158e313243924bbd
size     : 1376494
filetype : MS Office document
```

### Retrieve results

Get results through ```-File```, ```-Path```, ```-Hash```

```PowerShell
PS> Get-WildFireReport -File $(Get-Item "C:\tmp\mysuspiciousfile.docx") -Wait
PS> Get-WildFireReport -Path "C:\tmp\mysuspiciousfile.docx" -Wait -Verbose
PS> "aff65f0275e76eac3c9e3468d0d6e4cf78a0853c67c9dd4d1470afc104f952e9" | Get-WildFireReport
PS> Get-Item "C:\tmp\mysuspiciousfile.docx" | Get-WildFireReport

sha256                                                           verdict md5                              Result
------                                                           ------- ---                              ------
aff65f0275e76eac3c9e3468d0d6e4cf78a0853c67c9dd4d1470afc104f952e9 0       c3b07ec4f09a412a158e313243924bbd Benign
```

* Specify the ```-Wait``` flag to wait for results if analysis is in progress.
* Specify the ```-Timeout``` value to specify the maximum time to wait in seconds.
* Specify the ```-Interval``` value to specify the interval in seconds between each call.

[psgallery-badge]:      https://img.shields.io/powershellgallery/dt/PSWildfire.svg
[psgallery]:            https://www.powershellgallery.com/packages/PSWildfire