function Add-ConfigFile {
    param (
        [Parameter(Mandatory = $true)]
        # validates file path to confirm it a text file and not a folder
        [ValidateScript({Test-Path $_ -PathType 'Leaf'})]
        [string]$SourcePath,
    
        [Parameter(Mandatory = $true)]
        [string]$DestinationPath
    )
    
    # Copy the file
    Copy-Item -Path $SourcePath -Destination $DestinationPath -Force -ErrorAction Stop
    
    Write-Host "Configuration file copied from '$SourcePath' to '$DestinationPath'."
}

# Add-ConfigFile -SourcePath <src> -DestinationPath <des>