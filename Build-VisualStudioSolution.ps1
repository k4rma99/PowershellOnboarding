$global:vsPath = 'C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE\devenv.exe'
$global:solutionPath = 'C:\Path\to\Server.sln'

function Download-VisualStudioInstaller {
    $url = 'https://aka.ms/vs/16/release/vs_community.exe'
    $outputPath = "$env:TEMP\vs_community.exe"

    Write-Host "Downloading Visual Studio installer..."
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($url, $outputPath)

    $outputPath
}

function Build-VisualStudioSolution {
  
    if (-not (Test-Path $global:vsPath)) {
        Write-Host "Visual Studio executable not found at '$global:vsPath'."
        $installerPath = Download-VisualStudioInstaller

        if (-not $installerPath) {
            Write-Host "Failed to download Visual Studio installer. Aborting..."
            return
        }

        Write-Host "Installing Visual Studio..."
        Start-Process -Wait -FilePath $installerPath -ArgumentList '--quiet', '--installPath', "`"$($global:vsPath | Split-Path -Parent)`""

        if (-not (Test-Path $global:vsPath)) {
            Write-Host "Visual Studio installation failed. Aborting..."
            return
        }
    }

     if ($vsProcess) {
        Write-Host "Visual Studio live. $global:solutionPath"
        Start-Process -FilePath $global:vsPath -ArgumentList "/build", "$global:solutionPath"
    }
    else {
        Write-Host "Visual Studio dead. $global:solutionPath"

        $progressId = 1
        $progressMessage = "Starting Visual Studio..."
        Write-Progress -Id $progressId -Activity $progressMessage -Status "Please wait..."

        #
        Start-Process -FilePath $global:vsPath -ArgumentList "$global:solutionPath" -NoNewWindow -Wait

        $progressMessage = "Build Completed!"
        Write-Progress -Id $progressId -Activity $progressMessage -Completed
        Start-Sleep -Seconds 1
        Write-Progress -Id $progressId -Activity $progressMessage -Completed
    }
}

# Call the function
# Build-VisualStudioSolution
