function Perform-GitSetup {
    param (
        [Parameter(Mandatory = $true)]
        [string]$FileName,

        [Parameter(Mandatory = $true)]
        [string]$OriginUrl,

        [Parameter(Mandatory = $true)]
        [string]$UpstreamUrl,

        [string]$GitEmail = $null,
        [string]$GitUsername = $null
    )

    $desktopPath = [Environment]::GetFolderPath("Desktop")
    $directoryPath = Join-Path -Path $desktopPath -ChildPath $FileName

    if (-not (Test-Path $directoryPath -PathType 'Container')) {
        New-Item -ItemType Directory -Path $directoryPath | Out-Null
    }

    Set-Location -Path $directoryPath

    git init

    if ($GitEmail -and $GitUsername) {
        git config user.email $GitEmail
        git config user.name $GitUsername
    }

    git remote add origin $OriginUrl
    git remote add upstream $UpstreamUrl

    git clone $OriginUrl .

    Write-Host "Git setup complete. Changes pulled from origin."
}

# Usage example:
Perform-GitSetup -FileName "example.txt" -OriginUrl "https://github.com/yourusername/yourrepository.git" -UpstreamUrl "https://github.com/upstreamuser/upstreamrepository.git" -GitEmail "youremail@example.com" -GitUsername "Your Name"
