############################################################
# Update the following values before execution:
# - SQL Server Name
# - Database Name
# - Gmail Address
# - Gmail App Password
############################################################


# MODULES

Import-Module SqlServer
Import-Module ImportExcel


# CONFIGURATION


$ServerName = "."
$DatabaseName = "HospitalManagementDB"

$Username = "example@gmail.com"

$Password = ConvertTo-SecureString `
"<YOUR_GMAIL_APP_PASSWORD>" `
-AsPlainText -Force

$Credential = New-Object `
System.Management.Automation.PSCredential `
($Username,$Password)

$To = @($Username)

$TimeStamp = Get-Date -Format "yyyyMMdd_HHmmss"

$Folder = "$HOME\Temp"

New-Item -ItemType Directory -Path $Folder -Force | Out-Null

$MetaReportFile =
"$Folder\MetadataValidation_$TimeStamp.xlsx"

$ValidationReportFile =
"$Folder\ValidationReport_$TimeStamp.xlsx"

$LogFileName =
"$Folder\ValidationLog_$TimeStamp.log"

$ErrorActionPreference = "Stop"


# START LOGGING

Start-Transcript -Path $LogFileName

# EMAIL : STARTED


Send-MailMessage `
-From $Username `
-To $To `
-Subject "Validation Started" `
-SmtpServer "smtp.gmail.com" `
-Port 587 `
-UseSsl `
-Credential $Credential `
-Body "Validation process started."


# RUN METADATA VALIDATION

$MetaResults =
Invoke-Sqlcmd `
-Query "EXEC RunMetadataValidation" `
-ServerInstance $ServerName `
-Database $DatabaseName `
-TrustServerCertificate


# EXPORT METADATA REPORT

if($MetaResults.Count -eq 0)
{
    [PSCustomObject]@{
        Status = "Metadata Validation Passed"
        TimeStamp = Get-Date
    } | Export-Excel `
        -Path $MetaReportFile `
        -WorksheetName "MetadataStatus" `
        -AutoSize
}
else
{
    $MetaResults |
    Export-Excel `
    -Path $MetaReportFile `
    -WorksheetName "MetadataErrors" `
    -TableName "MetadataErrors" `
    -AutoSize `
    -BoldTopRow `
    -ExcludeProperty ItemArray,RowError,RowState,Table,HasErrors
}


# IF METADATA ERRORS EXIST


if($MetaResults.Count -gt 0)
{
    $Body = @"
Metadata validation failed.

Configuration errors were detected.

Data validation was NOT executed.

Please review the attached Metadata Validation Report.
"@

    Stop-Transcript

    Send-MailMessage `
    -From $Username `
    -To $To `
    -Subject "Metadata Validation Failed" `
    -SmtpServer "smtp.gmail.com" `
    -Port 587 `
    -UseSsl `
    -Credential $Credential `
    -Body $Body `
    -Attachments $MetaReportFile,$LogFileName

    return
}

# RUN DATA VALIDATION AND CAPTURE RESULTS


$ValidationResults =
Invoke-Sqlcmd `
-Query "EXEC RunValidation" `
-ServerInstance $ServerName `
-Database $DatabaseName `
-TrustServerCertificate


# EXPORT VALIDATION REPORT


$ValidationResults |
Export-Excel `
-Path $ValidationReportFile `
-WorksheetName "ValidationErrors" `
-TableName "ValidationErrors" `
-AutoSize `
-BoldTopRow `
-ExcludeProperty ItemArray,RowError,RowState,Table,HasErrors


# EMAIL SUCCESS


$Body = @"
Metadata validation passed.

Data validation completed successfully.

Please find attached:

1. Metadata Validation Report
2. Data Validation Report
3. Execution Log
"@

Stop-Transcript

Send-MailMessage `
-From $Username `
-To $To `
-Subject "Validation Completed Successfully" `
-SmtpServer "smtp.gmail.com" `
-Port 587 `
-UseSsl `
-Credential $Credential `
-Body $Body `
-Attachments `
$MetaReportFile,
$ValidationReportFile,
$LogFileName

# END LOGGING


Write-Host "Validation Process Completed Successfully"
