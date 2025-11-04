<#
.SYNOPSIS
    This PowerShell script Prevents the NetBIOS name from being released when requested by another computer — a security hardening setting to mitigate name release attacks.

.NOTES
    Author          : Arun George
    LinkedIn        : https://www.linkedin.com/in/georgearun1585
    GitHub          : https://github.com/georgearun1585
    Date Created    : 2025-11-04
    Last Modified   : 2025-11-04
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000035



.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\Set-NoNameReleaseOnDemand.ps1
#>


# Define registry path and settings
$RegPath = "HKLM:\SYSTEM\CurrentControlSet\Services\NetBT\Parameters"
$ValueName = "NoNameReleaseOnDemand"
$ExpectedValue = 1

# Check if the registry path exists
if (-not (Test-Path $RegPath)) {
    Write-Host "Registry path does not exist. Creating path..." -ForegroundColor Yellow
    New-Item -Path $RegPath -Force | Out-Null
}

# Check if the value exists
try {
    $CurrentValue = Get-ItemProperty -Path $RegPath -Name $ValueName -ErrorAction Stop | Select-Object -ExpandProperty $ValueName
    if ($CurrentValue -ne $ExpectedValue) {
        Write-Host "Non-compliant setting detected. Correcting value..." -ForegroundColor Yellow
        Set-ItemProperty -Path $RegPath -Name $ValueName -Value $ExpectedValue -Type DWord
    }
    else {
        Write-Host "Compliant: $ValueName is set to $ExpectedValue." -ForegroundColor Green
    }
}
catch {
    Write-Host "Value does not exist. Creating and setting it..." -ForegroundColor Yellow
    New-ItemProperty -Path $RegPath -Name $ValueName -Value $ExpectedValue -PropertyType DWord -Force | Out-Null
}

# Verify and display the final result
$FinalValue = (Get-ItemProperty -Path $RegPath -Name $ValueName).$ValueName
Write-Host "Final Registry State: $RegPath\$ValueName = $FinalValue (REG_DWORD)"
