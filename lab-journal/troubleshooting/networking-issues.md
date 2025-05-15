# Networking Issues and Solutions

## HTTP Error 500.0 - Internal Server Error with PHP/IIS

### Problem

When accessing the OSTicket setup page at http://localhost/osticket/setup/, received HTTP Error 500.0 with message:
"&lt;handler> scriptProcessor could not be found in &lt;fastCGI> application configuration"

### Cause

IIS couldn't find or run PHP for the site because:

- PHP wasn't properly registered with IIS as a FastCGI handler
- The path to php-cgi.exe was wrong or missing

### Solution

1. Register PHP with IIS as a FastCGI Handler:
   `Import-Module WebAdministration Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/handlers" -name "." -value @{name='PHP_via_FastCGI'; path='.php'; verb='';modules='FastCgiModule'; scriptProcessor='C:\PHP\php-cgi.exe';resourceType='Either'}`

2. Install URL Rewrite Module:
   `Invoke-WebRequest -Uri "https://download.microsoft.com/download/1/2/8/128E2E22-C1B9-44A4-BE2A-5859ED1D4592/rewrite_amd64_en-US.msi" -OutFile "rewrite_amd64.msi"`
   `Start-Process -FilePath "rewrite_amd64.msi" -ArgumentList "/quiet" -Wait`

3. Add PHP to the System PATH:
   `[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\PHP", "Machine")`
   `$env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine")`

4. Restart IIS: `iisreset`

## Network Connectivity Verification Issues

### Problem

Some services weren't accessible during connectivity testing:

- Print Services (port 515) test failed
- Security Monitoring (port 5044) test failed
- Email Services (port 25) test failed

### Cause

- Services not properly configured or not running
- Firewall rules not properly configured
- Incorrect port numbers or services not installed

### Solution

1. For Print Services:

- Verify that Print Spooler service is running
- Check firewall rules to allow port 515 (LPR) traffic
- Confirm printer is properly shared

2. For Security Monitoring:

- Confirm Security Onion is configured to listen on port 5044
- Verify firewall rules allow traffic between workstations and Security Onion
- Check Winlogbeat configuration on client systems

3. For Email Services:

- This is a planned future implementation
- Need to set up mail server or relay on pfSense

## Help Desk Account Access Issues

### Problem

Unable to log in with help-desk account, error message:
"We can't sign you in with this credential because your domain isn't available. Make sure your device is connected to your organization's network and try again."

### Cause

Default Group Policy restricted "Allow log on locally" permissions, preventing help-desk accounts from logging in.

### Solution

1. Created a GPO called "Workstation Logon Rights"
2. Set Computer Configuration → Windows Settings → Security Settings → Local Policies → User Rights Assignment → "Allow log on locally"
3. Added the following groups:

- Domain Admins
- Help Desk
- System Administrators

4. Applied the GPO to appropriate organizational units
5. Ran `gpupdate /force` to apply changes immediately

## RSAT Installation Failure

### Problem

Couldn't install Remote Server Administration Tools (RSAT) from IT workstation.

### Cause

Group Policy was directing feature installation requests to WSUS instead of Windows Update.

### Solution

1. Modified Local Group Policy:

- Opened Local Group Policy Editor (gpedit.msc)
- Navigated to Computer Configuration → Administrative Templates → System
- Edited "Specify settings for optional component installation and component repair"
- Enabled and checked "Download repair content and optional features directly from Windows Update"

2. Applied changes with `gpupdate /force`
3. Successfully installed RSAT using:
   `Get-WindowsCapability -Name RSAT.ActiveDirectory* -Online | Add-WindowsCapability -Online`
4. Imported the AD module with `Import-Module ActiveDirectory`
