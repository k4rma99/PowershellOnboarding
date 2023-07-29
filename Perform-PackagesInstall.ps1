function Install-AngularCli {
    $npmCommand = "npm install -g @angular/cli@9.1.12"

    Write-Host "Installing Angular CLI..."
    Invoke-Expression -Command $npmCommand
}

function Install-NpmGruntBower {
    $npmCommand = "npm i -g grunt bower"

    Write-Host "Installing Grunt and Bower globally"
    Invoke-Expression -Command $npmCommand
}

function Test-ValidUrl {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Url
    )

    try {
        $request = [System.Net.WebRequest]::Create($Url)
        $request.Method = "HEAD"
        $response = $request.GetResponse()
        return $response.StatusCode -eq [System.Net.HttpStatusCode]::OK
    } catch {
        return $false
    }
}

function Install-FromUrlFromExcel {

    $ExcelFilePath = "C:\Users\user\Desktop\Onboarding automation\softwares.xlsx"
    $DesktopPath = [Environment]::GetFolderPath('Desktop')
    $installersPath = Join-Path -Path $DesktopPath -ChildPath "Installers"

    if (-not (Test-Path $installersPath -PathType 'Container')) {
        New-Item -ItemType Directory -Path $installersPath | Out-Null
    }

    # Remove from code. Needs to be added in main code. 
    Set-Location -Path "C:\Users\user\Desktop\Onboarding automation"

    # Import data from the specified Excel file
    $installersData = Import-Excel -Path $ExcelFilePath

    # To store the filenames
    $global:fileNames = @()

    # Loop through the installers data and download the files
    foreach ($installerData in $installersData) {
        $installerUrl = $installerData.Installer

        # Check if URL is valid
        if (-not (Test-ValidUrl $installerUrl)) {
            Write-Host "URL not found. Skipping install."
            continue
        }

        $fileName = Split-Path -Leaf $installerUrl
        $filePath = Join-Path -Path $installersPath -ChildPath $fileName

        # Define the event handler for DownloadProgressChanged
        Add-Type -TypeDefinition 
@"
            using System;
            using System.Net;

            public class WebClientWithProgress : WebClient
            {
                public WebClientWithProgress()
                {
                }

                public event EventHandler<DownloadProgressChangedEventArgs> DownloadProgressChanged;

                protected virtual void OnDownloadProgressChanged(DownloadProgressChangedEventArgs e)
                {
                    DownloadProgressChanged?.Invoke(this, e);
                }

                protected override void OnDownloadProgressChanged(DownloadProgressChangedEventArgs e)
                {
                    base.OnDownloadProgressChanged(e);

                    int progressPercentage = (int)((e.BytesReceived * 100) / e.TotalBytesToReceive);
                    OnDownloadProgressChanged(new DownloadProgressChangedEventArgs(progressPercentage, null, e.BytesReceived, e.TotalBytesToReceive, null));
                }
            }
"@


        # Download the file using the WebClient with progress reporting
        $webClient = New-Object System.Net.WebClient

        # Subscribe to the DownloadProgressChanged event
        $webClient.DownloadProgressChanged += {
            param ($sender, $args)
            Write-Host "Download Progress: $($args.ProgressPercentage)%"
        }

        # Start the download
        $webClient.DownloadFile($installerUrl, $filePath)

        # Unsubscribe from the event to avoid potential memory leaks
        $webClient.DownloadProgressChanged -= $null

        $fileNames += $fileName
    }

    $fileNames
}

Install-FromUrlFromExcel