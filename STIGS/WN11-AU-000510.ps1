<#
.SYNOPSIS
  Ensures the System Event Log MaxSize is configured correctly.
  STIG Requirement: HKLM\SOFTWARE\Policies\Microsoft\Windows\EventLog\System\MaxSize >= 32768

.DESCRIPTION
  This script checks whether the System Event Log MaxSize registry value
  exists and is configured to 32,768 KB (32 MB) or greater.
  If not, it creates or updates the value accordingly.

.NOTES
  Run this script as Administrator.
  If audit logs are sent directly to a remote audit server, this control is Not Applicable (NA)
  and must be documented by the ISSO.
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
    PS C:\> .\Set-SystemEventLogMaxSize.ps1

#>

# Define registry path and settings
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\System"
$ValueName = "MaxSize"
$MinimumValue = 32768  # 0x00008000 (in KB)

# Check if system is configured to send audit logs remotely (NA condition)
# You can insert your organization's specific detection logic here.
# Example placeholder:
$AuditServerConfigured = $false  # Set to $true if verified manually or by config

if ($AuditServerConfigured) {
    Write-Host "Audit records are sent directly to an audit server. This setting is Not Applicable (NA)." -ForegroundColor Cyan
    return
}

# Ensure registry path exists
if (-not (Test-Path $RegPath)) {
    Write-Host "Registry path does not exist. Creating it..." -ForegroundColor Yellow
    New-Item -Path $RegPath -Force | Out-Null
}

# Try to read current value
try {
    $CurrentValue = (Get-ItemProperty -Path $RegPath -Name $ValueName -ErrorAction Stop).$ValueName
    if ($CurrentValue -lt $MinimumValue) {
        Write-Host "Non-compliant: Current MaxSize = $CurrentValue KB. Updating to $MinimumValue KB..." -ForegroundColor Yellow
        Set-ItemProperty -Path $RegPath -Name $ValueName -Value $MinimumValue -Type DWord
    } else {
        Write-Host "Compliant: MaxSize = $CurrentValue KB (>= $MinimumValue KB)." -ForegroundColor Green
    }
}
catch {
    Write-Host "Registry value not found. Creating and setting it to $MinimumValue KB..." -ForegroundColor Yellow
    New-ItemProperty -Path $RegPath -Name $ValueName -Value $MinimumValue -PropertyType DWord -Force | Out-Null
}

# Display final state
$FinalValue = (Get-ItemProperty -Path $RegPath -Name $ValueName).$ValueName
Write-Host "Final Registry State: $RegPath\$ValueName = $FinalValue (REG_DWORD)" -ForegroundColor White
