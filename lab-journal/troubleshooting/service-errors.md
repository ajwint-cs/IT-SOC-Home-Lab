# Service Configuration Issues and Solutions

## PHP Extension Issues with OSTicket

### Problem

OSTicket installation page showed missing PHP extensions that were required or recommended for full functionality.

### Cause

Default PHP installation had several extensions disabled in php.ini file.

### Solution

1. Located the php.ini file in C:\PHP directory
2. Removed the semicolon (;) comment marker before required extensions:
   extension=gd
   extension=imap
   extension=mysqli
   extension=openssl
   extension=phar
   extension=mbstring
   extension=xml
   extension=json
3. Restarted IIS service: `iisreset`
4. Verified extensions were loaded through phpinfo.php test page

## Print Service Connectivity Issues

### Problem

Unable to connect to print services on SRV-PRINT-TICKET:
`Test-NetConnection -ComputerName 10.1.10.20 -Port 515`
Test failed.

### Cause

1. Print service might not be using LPR protocol (port 515)
2. Windows Print Service uses different ports by default
3. Firewall rules may be blocking the connection

### Solution

1. Verified Print Spooler service was running:
   `Get-Service -Name Spooler`
2. Added firewall rules for printer sharing:
   `New-NetFirewallRule -DisplayName "Print Server (TCP-In)" -Direction Inbound -Protocol TCP -LocalPort 445,135,139 -Action Allow`
3. Enabled printer sharing in Windows Firewall with predefined rules:

- File and Printer Sharing (SMB-In)
- File and Printer Sharing (Spooler Service - RPC)
- File and Printer Sharing (Spooler Service - RPC-EPMAP)

4. Used correct port for testing (port 9100 for modern print services):
   `Test-NetConnection -ComputerName 10.1.10.20 -Port 9100`
   Test failed.

### Cause

1. Security Onion might not be listening on port 5044
2. Firewall rules blocking the connection
3. Winlogbeat not properly configured

### Solution

1. Verified Security Onion was properly configured to receive logs:
   - Checked Logstash configuration for port 5044 listener
   - Ensured SSL certificates were properly configured
2. Added firewall rule on Security Onion:
   `sudo firewall-cmd --permanent --add-port=5044/tcp`
   `sudo firewall-cmd --reload`
3. Modified Winlogbeat configuration:

- Verified hosts setting pointed to correct IP and port
- Checked SSL certificate configuration
- Restarted Winlogbeat service:
  ```
  Restart-Service winlogbeat
  ```

4. Monitored log file for connection errors:
   `Get-Content -Path "C:\ProgramData\winlogbeat\Logs\winlogbeat.log" -Tail 20`

## Group Policy Application Issues

### Problem

Group policy settings not applying correctly to workstations.

### Cause

1. Group Policy processing order confusion
2. Conflicting policies at different levels
3. GPO not linked to correct organizational unit

### Solution

1. Reviewed Group Policy precedence order (LSDOU):

- Local Group Policy
- Site GPOs
- Domain GPOs
- Organizational Unit GPOs

2. Used Group Policy Results tool to troubleshoot:
   `gpresult /h C:\temp\gpreport.html`
3. Fixed OU structure to ensure policies applied to correct computers
4. Used Group Policy Modeling for testing:
   `Get-GPResultantSetOfPolicy -Computer "WORKSTATION1" -User "LAB\JJazz" -ReportType Html -Path "C:\temp\gpmodel.html"`
5. Forced policy update on affected machines:
   `Invoke-GPUpdate -Computer "WORKSTATION1" -Force`

## Future Implementation ToDos

### Email Services Setup

1. Install and configure mail server on dedicated VM or pfSense
2. Configure SMTP relay for internal services
3. Set up email integration with OSTicket
4. Test connectivity using:
   `Test-NetConnection -ComputerName <mail_server> -Port 25`

### Security Monitoring Enhancement

1. Complete Winlogbeat configuration on all endpoints
2. Configure Security Onion dashboards for proper visibility
3. Set up automated alerting for security events
4. Integrate with OSTicket for automated ticket creation
