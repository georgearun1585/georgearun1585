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
    STIG-ID         : WN11-CC-000290

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\__remediation_template(STIG-ID-WN11-CC-000290).ps1 
#>
# Define registry configuration
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
$ValueName = "MinEncryptionLevel"
$ExpectedValue = 3

Write-Host "Checking Remote Desktop minimum encryption level policy..." -ForegroundColor Cyan

# Create the registry key if it does not exist
if (-not (Test-Path -Path $RegPath)) {
    Write-Host "Registry path does not exist. Creating it..." -ForegroundColor Yellow
    New-Item -Path $RegPath -Force | Out-Null
}

try {
    # Read the current value
    $CurrentValue = (Get-ItemProperty -Path $RegPath -Name $ValueName -ErrorAction Stop).$ValueName

    if ($CurrentValue -ne $ExpectedValue) {
        Write-Host "Non-compliant: Current value is $CurrentValue. Updating to $ExpectedValue..." -ForegroundColor Yellow

        Set-ItemProperty -Path $RegPath `
            -Name $ValueName `
            -Value $ExpectedValue `
            -Type DWord
    }
    else {
        Write-Host "Compliant: $ValueName is set to $ExpectedValue." -ForegroundColor Green
    }
}
catch {
    Write-Host "Registry value not found. Creating it with value $ExpectedValue..." -ForegroundColor Yellow

    New-ItemProperty -Path $RegPath `
        -Name $ValueName `
        -Value $ExpectedValue `
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
