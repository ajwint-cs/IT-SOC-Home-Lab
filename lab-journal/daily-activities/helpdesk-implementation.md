# Help Desk Implementation Activities

## May 11-12: OSTicket Setup and Configuration

### SRV-PRINT-TICKET (10.1.10.20) Setup

#### VM Configuration

- **Resources**: 2 vCPUs, 6GB RAM, 80GB Storage
- **OS**: Windows Server 2022 Standard Evaluation (Desktop Experience)
- **Network**: Static IP 10.1.10.20, Gateway 10.1.10.1, DNS 10.1.10.2
- **Domain**: Joined to lab.local

#### Print Server Role Setup

1. Installed Print Server role through Server Manager
2. Configured simulated network printer:
   - Added TCP/IP printer at 10.1.10.100 (simulated)
   - Named port: PRINTER-01
   - Used Generic / Text Only driver
   - Shared as: LAB-PRINTER01
3. Created GPO "Deploy Lab Printers" for automatic printer deployment

#### OSTicket Implementation

##### Prerequisites Installation

1. Installed IIS with required features:
   `Install-WindowsFeature -Name Web-Server, Web-Mgmt-Console, Web-CGI, Web-Asp-Net45`

2. PHP Configuration:

- Downloaded PHP 8.2.28 from windows.php.net
- Created directory at C:\PHP and extracted files
- Renamed php.ini-production to php.ini
- Enabled required extensions:
  - mysqli
  - openssl
  - gd
  - imap
  - xml
  - json

3. FastCGI Configuration:

- Added PHP as FastCGI handler in IIS
- Set environment variables:
  - PHP_FCGI_MAX_REQUESTS: 10000
  - PHPRC: C:\PHP\php.ini

4. MySQL Installation:

- Installed MySQL Server
- Created osticket database and user
- Set appropriate permissions

5. OSTicket Installation:

- Downloaded and extracted to C:\inetpub\wwwroot\osticket
- Set appropriate permissions on ost-config.php
- Completed web-based installation

#### OSTicket Configuration

##### System Settings

- Helpdesk Name: IT Help Desk
- Default Email: helpdesk@lab.local

##### Admin User

- Username: it-admin-osticket
- Password: IT!-H3lpD3sk2025!

##### Departments

Created the following departments:

- IT Help Desk
- Technical Support
- Infrastructure
- Security
- Asset Management
- Support (Default)

##### Teams

Set up the following teams:

- Level I Support
- Level II Support
- Infrastructure Team
- Security Team

##### Agent Accounts

1. **Help Desk Technician**

- Name: John Smith
- Email: john.smith@lab.local
- Username: jsmith
- Departments: IT Help Desk (Primary)
- Role: Limited Access
- Teams: Level I Support

2. **Senior Support Specialist**

- Name: Sarah Johnson
- Email: sarah.johnson@lab.local
- Username: sjohnson
- Departments: Technical Support (Primary), Infrastructure (Extended)
- Role: Expanded Access
- Teams: Level I Support, Level II Support

3. **IT Manager**

- Name: Michael Chen
- Email: michael.chen@lab.local
- Username: mchen
- Administrator: Yes
- Departments: Infrastructure (Primary), Security (Extended)
- Role: All Access
- Teams: Level II Support

4. **Security Specialist**

- Name: Alex Rivera
- Email: alex.rivera@lab.local
- Username: arivera
- Limited to assigned tickets only: Yes
- Departments: Security (Primary)
- Role: Expanded Access
- Teams: Security Team

##### SLA Plans

Created three service level agreement tiers:

- Sev-A (Critical): 1-hour response, 4-hour resolution
- Sev-B (High): 4-hour response, 8-hour resolution
- Sev-C (Normal): 8-hour response, 24-hour resolution

##### Ticket Filters

Implemented automated ticket routing:

1. **Password Reset Auto-Assignment**

- Execution Order: 10
- Filter Rules: Issue Summary contains "password reset" OR "urgent" OR "locked out"
- Actions:
  - Set Priority: High
  - Set SLA Plan: Sev-B (High)
  - Assign Team: Level I Support
  - Set Department: IT Help Desk

2. **Network Issues Router** (planned)

- Will route network issues to Infrastructure department

3. **Security Incident Escalation** (planned)

- Will immediately escalate security incidents to Security team

##### Test Tickets

Created and processed test tickets to verify functionality:

- Password reset request
- Account lockout scenario

## May 14: Help Desk System Review

- Reviewed ServiceNow features for potential future implementation
- Compared OSTicket functionality with enterprise-grade systems
- Identified opportunities for workflow automation

## Key Learning Moments

- Ticket automation is critical for proper routing to correct departments
- SLA tiers provide accountability and prioritization for different issue severities
- Departmental separation ensures specialized teams handle appropriate issues
- Proper help desk system configuration significantly reduces response times
