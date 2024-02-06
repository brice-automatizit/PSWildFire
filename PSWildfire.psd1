﻿#
# Module manifest for module 'PSWildfire'
#
# Generated by: Brice Crunchant
#
# Generated on: 02/06/2024
#

@{

    # Script module or binary module file associated with this manifest.
    RootModule           = 'PSWildfire.psm1'

    # Version number of this module.
    ModuleVersion        = '1.0.0'

    # Supported PSEditions
    CompatiblePSEditions = 'Desktop', 'Core'

    # ID used to uniquely identify this module
    GUID                 = 'de2c7946-1ffa-4bb1-8cdf-3e3e8722ad85'

    # Author of this module
    Author               = 'Brice Crunchant'

    # Company or vendor of this module
    CompanyName          = 'AutomatizIT'

    # Copyright statement for this module
    Copyright            = '(c) 2024 Brice Crunchant. All rights reserved.'

    # Description of the functionality provided by this module
    Description          = 'Palo Alto Wildfire PS Module API Wrapper'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion    = '5.1'

    # Name of the Windows PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the Windows PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # CLRVersion = ''

    # Processor architecture (None, X86, Amd64) required by this module
    # ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module
    # RequiredModules = @()

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    # NestedModules = @()

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport    = 'Connect-Wildfire','ConvertTo-WildfireBody', 'Get-WildfireReport', 'Send-FileToWildFire', 'Test-WildfireConnection'

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport      = '*'

    # Variables to export from this module
    # VariablesToExport = @()

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport      = '*'

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    # FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData          = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags         = 'Palo Alto', 'Sandbox', 'Reporting', 'Report', 'Analysis'

            # A URL to the license for this module.
            LicenseUri   = 'https://github.com/brice-automatizit/PSWildfire/blob/main/LICENSE'

            # A URL to the main website for this project.
            ProjectUri   = 'https://github.com/brice-automatizit/PSWildfire'

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            ReleaseNotes = 'Initial Version'

            # External dependent modules of this module
            # ExternalModuleDependencies = ''

        } # End of PSData hashtable
    
    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    HelpInfoURI          = 'https://github.com/brice-automatizit/PSWildfire'

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}