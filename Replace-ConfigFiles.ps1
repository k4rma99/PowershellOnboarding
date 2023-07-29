function Replace-ConfigFile {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ProjectPath,

        [Parameter(Mandatory = $true)]
        [string]$SourceConfigFile
    )

    if (-not (Test-Path $ProjectPath -PathType 'Container')) {
        Write-Host "Project path '$ProjectPath' does not exist or is not a directory. Please check the path."
        return
    }

    if (-not (Test-Path $SourceConfigFile -PathType 'Leaf')) {
        Write-Host "Source config file '$SourceConfigFile' does not exist or is not a file. Please check the path."
        return
    }

    $destinationConfigFile = Join-Path -Path $ProjectPath -ChildPath (Get-Item $SourceConfigFile).Name

    if (-not (Test-Path $destinationConfigFile -PathType 'Leaf')) {
        Write-Host "Destination config file '$destinationConfigFile' does not exist in the solution. Please check the file name."
        return
    }

    Copy-Item -Path $SourceConfigFile -Destination $destinationConfigFile -Force
    Write-Host "Replaced the existing config file in the solution with '$SourceConfigFile'."
}

#Replace-ConfigFile "C:\Users\user\Desktop\Test1\B" "C:\Users\user\Desktop\c1.txt"