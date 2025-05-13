# Security Checks Script for Domain Controllers and Network Servers
# This script combines health checks and disk cleanup operations
# Schedule to run daily or weekly via Task Scheduler

#################################################
# PART 1: SYSTEM HEALTH CHECK
#################################################

$ErrorActionPreference = "SilentlyContinue"
$ReportPath = "C:\Reports\HealthCheck-$(Get-Date -Format 'yyyy-MM-dd').log"

# Check if Reports directory exists, if not create it
if (!(Test-Path "C:\Reports")) {
    New-Item -Path "C:\Reports" -ItemType Directory
}

# Initialize report
"===== System Health Check $(Get-Date) =====" | Out-File -FilePath $ReportPath

# 1. Check disk space
"DISK SPACE:" | Out-File -FilePath $ReportPath -Append
Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3" | 
    Select-Object DeviceID, 
        @{Name="Size(GB)";Expression={[math]::Round($_.Size/1GB,2)}}, 
        @{Name="FreeSpace(GB)";Expression={[math]::Round($_.FreeSpace/1GB,2)}}, 
        @{Name="% Free";Expression={[math]::Round(($_.FreeSpace/$_.Size)*100,2)}} |
    Format-Table -AutoSize | Out-File -FilePath $ReportPath -Append

# 2. Check critical services
"CRITICAL SERVICES:" | Out-File -FilePath $ReportPath -Append
$CriticalServices = @("ADWS", "DNS", "DFS", "DFSR", "Dnscache", "gpsvc", "NTDS", "Netlogon")
Get-Service $CriticalServices | 
    Select-Object Name, DisplayName, Status |
    Format-Table -AutoSize | Out-File -FilePath $ReportPath -Append

# 3. Check AD Replication
"AD REPLICATION STATUS:" | Out-File -FilePath $ReportPath -Append
repadmin /showrepl | Out-File -FilePath $ReportPath -Append

# 4. Check Event Logs for Errors
"CRITICAL EVENTS (Last 24 Hours):" | Out-File -FilePath $ReportPath -Append
Get-EventLog -LogName System -EntryType Error,Warning -After (Get-Date).AddDays(-1) | 
    Select-Object TimeGenerated, EntryType, Source, EventID, Message |
    Format-Table -AutoSize | Out-File -FilePath $ReportPath -Append

# 5. Check DCDIAG
"DCDIAG RESULTS:" | Out-File -FilePath $ReportPath -Append
dcdiag /s:$env:COMPUTERNAME | Out-File -FilePath $ReportPath -Append

# 6. Check for Security Updates
"PENDING SECURITY UPDATES:" | Out-File -FilePath $ReportPath -Append
Get-HotFix | Sort-Object -Property InstalledOn -Descending | 
    Select-Object -First 10 HotFixID, Description, InstalledOn |
    Format-Table -AutoSize | Out-File -FilePath $ReportPath -Append

# 7. Check for Unauthorized Admin Accounts
"DOMAIN ADMIN GROUP MEMBERS:" | Out-File -FilePath $ReportPath -Append
Get-ADGroupMember "Domain Admins" | 
    Get-ADUser -Properties Name, Enabled, LastLogonDate |
    Select-Object Name, Enabled, LastLogonDate | 
    Format-Table -AutoSize | Out-File -FilePath $ReportPath -Append

# Email the report if needed
# Send-MailMessage -From "monitoring@lab.local" -To "admin@lab.local" -Subject "Daily Health Check" -Attachments $ReportPath -SmtpServer "mail.lab.local"

Write-Host "Health check completed. Report saved to $ReportPath"

#################################################
# PART 2: DISK CLEANUP
#################################################

# Temp files older than 30 days
Write-Host "Cleaning up Windows temp files..." -ForegroundColor Yellow
Get-ChildItem "C:\Windows\Temp" -Recurse | 
Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-30)} | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

# User temp files
Write-Host "Cleaning up user temp files..." -ForegroundColor Yellow
Get-ChildItem "C:\Users\*\AppData\Local\Temp" -Recurse | 
Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-30)} | 
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

# Windows update cleanup
Write-Host "Running Windows disk cleanup..." -ForegroundColor Yellow
Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -Wait

# IIS Logs (if applicable)
if (Test-Path "C:\inetpub\logs\LogFiles") {
    Write-Host "Cleaning up IIS logs..." -ForegroundColor Yellow
    Get-ChildItem "C:\inetpub\logs\LogFiles" -Recurse | 
    Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-90)} | 
    Remove-Item -Force -ErrorAction SilentlyContinue
}

# Event logs backup and clearing (optional)
<#
Write-Host "Backing up and clearing event logs..." -ForegroundColor Yellow
$LogDate = Get-Date -Format "yyyyMMdd"
$LogNames = @("System", "Application", "Security")

foreach ($log in $LogNames) {
    wevtutil epl $log "C:\Reports\$log-$LogDate.evtx"
    wevtutil cl $log
}
#>

Write-Host "Disk cleanup completed successfully" -ForegroundColor Green

# Add cleanup details to report
"DISK CLEANUP RESULTS:" | Out-File -FilePath $ReportPath -Append
"Cleanup completed at $(Get-Date)" | Out-File -FilePath $ReportPath -Append

# Final disk space after cleanup
"DISK SPACE AFTER CLEANUP:" | Out-File -FilePath $ReportPath -Append
Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3" | 
    Select-Object DeviceID, 
        @{Name="Size(GB)";Expression={[math]::Round($_.Size/1GB,2)}}, 
        @{Name="FreeSpace(GB)";Expression={[math]::Round($_.FreeSpace/1GB,2)}}, 
        @{Name="% Free";Expression={[math]::Round(($_.FreeSpace/$_.Size)*100,2)}} |
    Format-Table -AutoSize | Out-File -FilePath $ReportPath -Append
