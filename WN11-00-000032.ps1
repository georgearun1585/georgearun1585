<#
.SYNOPSIS
    This PowerShell script ensures that Windows 11 systems must use a BitLocker PIN with a minimum length of six digits for pre-boot authentication.

.NOTES
    Author          : Arun George
    LinkedIn        : https://www.linkedin.com/in/georgearun1585
    GitHub          : https://github.com/georgearun1585
    Date Created    : 2026-06-29
    Last Modified   : 2026-06-29
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-00-000032

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\__remediation_template(STIG-ID-WN11-00-000032).ps1 
#>
# Define registry configuration
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"
$ValueName = "MinimumPIN"
$MinimumValue = 6

Write-Host "Checking BitLocker Minimum PIN policy..." -ForegroundColor Cyan

# Create the registry key if it does not exist
if (-not (Test-Path -Path $RegPath)) {
    Write-Host "Registry path does not exist. Creating it..." -ForegroundColor Yellow
    New-Item -Path $RegPath -Force | Out-Null
}

try {
    # Read the current value
    $CurrentValue = (Get-ItemProperty -Path $RegPath -Name $ValueName -ErrorAction Stop).$ValueName

    if ($CurrentValue -lt $MinimumValue) {
        Write-Host "Non-compliant: Current value is $CurrentValue. Updating to $MinimumValue..." -ForegroundColor Yellow

        Set-ItemProperty -Path $RegPath `
            -Name $ValueName `
            -Value $MinimumValue `
            -Type DWord
    }
    else {
        Write-Host "Compliant: $ValueName is set to $CurrentValue (minimum required is $MinimumValue)." -ForegroundColor Green
    }
}
catch {
    Write-Host "Registry value not found. Creating it with value $MinimumValue..." -ForegroundColor Yellow

    New-ItemProperty -Path $RegPath `
        -Name $ValueName `
        -Value $MinimumValue `
        -PropertyType DWord `
        -Force | Out-Null
}

# Verify the final configuration
$FinalValue = (Get-ItemProperty -Path $RegPath -Name $ValueName).$ValueName

Write-Host ""
Write-Host "Final Registry State:" -ForegroundColor Cyan
Write-Host "  Path : $RegPath"
Write-Host "  Name : $ValueName"
Write-Host "  Type : REG_DWORD"
Write-Host "  Value: $FinalValue"
