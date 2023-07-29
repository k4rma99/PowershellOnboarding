function Create-ConfigFile {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ConfigDocumentPath,

        [Parameter(Mandatory = $true)]
        [string]$CsvFilePath
    )

    if (-not (Test-Path $ConfigDocumentPath -PathType 'Leaf')) {
        Write-Host "Config document '$ConfigDocumentPath' does not exist or is not a file. Please check the path."
        return
    }

    if (-not (Test-Path $CsvFilePath -PathType 'Leaf')) {
        Write-Host "CSV file '$CsvFilePath' does not exist or is not a file. Please check the path."
        return
    }

    $configValues = @{}
    Import-Csv -Path $CsvFilePath | ForEach-Object { $configValues[$_.Key] = $_.Value }

    $configContent = Get-Content -Path $ConfigDocumentPath

    foreach ($key in $configValues.Keys) {
        $placeholder = "<$key>"
        $configContent = $configContent -replace $placeholder, $configValues[$key]
    }

    $configContent | Set-Content -Path $ConfigDocumentPath

    Write-Host "Configuration document updated successfully using the CSV file data."
}

#Create-ConfigFile "C:\Users\user\Desktop\New Text Document.txt" "C:\Users\user\Desktop\test.csv"