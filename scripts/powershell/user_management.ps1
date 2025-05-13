# Create multiple users in Active Directory with department attributes
# Example usage: .\Create-BulkUsers.ps1 -Count 20 -Department "Finance"

param (
    [int]$Count = 10,
    [string]$Department = "IT",
    [string]$OUPath = "OU=$Department,DC=lab,DC=local"
)

# Ensure OU exists
try {
    Get-ADOrganizationalUnit -Identity $OUPath
} catch {
    New-ADOrganizationalUnit -Name $Department -Path "DC=lab,DC=local"
    Write-Host "Created OU: $Department"
}

# Create users
1..$Count | ForEach-Object {
    $Username = "user$_"
    $DisplayName = "Test User $_"
    $UPN = "$Username@lab.local"
    
    # Generate secure password
    $SecurePassword = ConvertTo-SecureString "[EXAMPLE-PASSWORD-ONLY]: T3st!Us3r#$_@2025" -AsPlainText -Force
    
    # Create user
    New-ADUser -Name $DisplayName -GivenName "Test" -Surname "User$_" -SamAccountName $Username `
        -UserPrincipalName $UPN -Path $OUPath -Department $Department -Enabled $true `
        -AccountPassword $SecurePassword -PasswordNeverExpires $false `
        -ChangePasswordAtLogon $true
        
    Write-Host "Created user: $Username in $Department department"
}
