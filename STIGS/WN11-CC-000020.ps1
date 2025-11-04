<#
.SYNOPSIS
  Ensures IPv6 source routing is disabled (STIG / CIS compliance).
  Registry: HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters
  Value: DisableIpSourceRouting = 2

.DESCRIPTION
  This script checks if the 'DisableIpSourceRouting' value exists and is set to 2.
  If not, it creates or updates it.
  Setting this to 2 disables all source routing — a critical hardening measure.

.NOTES
  Run this script as Administrator.
  Author          : Arun George
    LinkedIn        : https://www.linkedin.com/in/georgearun1585
    GitHub          : https://github.com/georgearun1585
    Date Created    : 2025-11-04
    Last Modified   : 2025-11-04
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AU-000510

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\Set-DisableIpSourceRouting.ps1


#>

# Define registry configuration
$RegPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters"
$ValueName = "DisableIpSourceRouting"
$ExpectedValue = 2

Write-Host "Checking IPv6 Source Routing configuration..." -ForegroundColor Cyan

# Ensure registry path exists
if (-not (Test-Path $RegPath)) {
    Write-Host "Registry path does not exist. Creating it..." -ForegroundColor Yellow
    New-Item -Path $RegPath -Force | Out-Null
}

# Try reading the current value
try {
    $CurrentValue = (Get-ItemProperty -Path $RegPath -Name $ValueName -ErrorAction Stop).$ValueName

    if ($CurrentValue -ne $ExpectedValue) {
        Write-Host "Non-compliant: Current value = $CurrentValue. Setting to $ExpectedValue..." -ForegroundColor Yellow
        Set-ItemProperty -Path $RegPath -Name $ValueName -Value $ExpectedValue -Type DWord
    }
    else {
        Write-Host "Compliant: $ValueName is set to $ExpectedValue." -ForegroundColor Green
    }
}
catch {
    Write-Host "Value not found. Creating and setting it to $ExpectedValue..." -ForegroundColor Yellow
    New-ItemProperty -Path $RegPath -Name $ValueName -Value $ExpectedValue -PropertyType DWord -Force | Out-Null
}

# Display final state
$FinalValue = (Get-ItemProperty -Path $RegPath -Name $ValueName).$ValueName
Write-Host "Final Registry State: $RegPath\$ValueName = $FinalValue (REG_DWORD)" -ForegroundColor White
