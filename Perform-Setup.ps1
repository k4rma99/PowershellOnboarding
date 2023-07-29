function Invoke-SnapSetup{

    param(
        
        [Parameter(Mandatory = $true)]
        [string]$SetupCsvPath
    
    )

    if (-not (Test-Path $SetupCsvPath -PathType 'Leaf')) {
        Write-Host "CSV file '$SetupCsvPath' does not exist or is not a file. Please check the path."
        return
    }

    # Module to handle excel parsing 
    # Install-Module -Name ImportExcel

    # The Excel sheet basically is divided to sheets
    # Sheets are extracted and the data in it send to different scripts
   

    # Import data from a specific sheet in the Excel file
    $excelFilePath = "C:\Users\user\Desktop\test_excel.xlsx"
    $configSheet = "AppConfigDetails"
    $userDetails = "DataSheet"

    # Import data from the specified sheet
    $configData = Import-Excel -Path $excelFilePath -WorksheetName $configSheet
    $userDetails = Import-Excel -Path $excelFilePath -WorksheetName $configSheet

    Perform-PackageInstall
    Perform-ConfigSetup
    Perform-GitTasks -FileName $FileName -OriginUrl $OriginUrl -UpstreamUrl $UpstreamUrl -GitEmail $GitEmail -GitUsername $GitUsername
}