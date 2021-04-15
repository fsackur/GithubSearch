@{
    Description          = 'Search GitHub. Supports GitHub Enterprise.'
    ModuleVersion        = '0.0.1'
    HelpInfoURI          = 'https://pages.github.com/fsackur/GithubSearch'

    CompatiblePSEditions = @('Desktop', 'Core')
    PowerShellVersion    = '5.1'

    Author               = 'Freddie Sackur'
    CompanyName          = 'DustyFox'
    Copyright            = '(c) 2021 Freddie Sackur. All rights reserved.'

    GUID                 = '3a200fc7-45c4-4929-a16f-c586e11fa213'

    RootModule           = 'GithubSearch.psm1'

    RequiredModules      = @()

    FunctionsToExport    = @(
        '*'
    )

    PrivateData          = @{
        PSData = @{
            LicenseUri = 'https://raw.githubusercontent.com/fsackur/GithubSearch/main/LICENSE'
            ProjectUri = 'https://github.com/fsackur/GithubSearch'
            Tags       = @(
                'GitHub',
                'Search',
                'Find'
            )
        }
    }
}
