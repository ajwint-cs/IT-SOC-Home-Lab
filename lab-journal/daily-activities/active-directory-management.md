# Active Directory Management Activities

## May 8: User Account Management & Tiered Access Model

### Domain Structure Implementation

- Configured Windows Server 2022 as Domain Controller for lab.local
- Set up DNS services with primary DNS 127.0.0.1 and secondary DNS 8.8.8.8
- Implemented forest functional level at Windows Server 2022

### Help Desk Access Delegation

- Created dedicated Help Desk Security Group
- Delegated the following permissions via Delegation of Control wizard:
  - Create, delete, and manage user accounts
  - Reset user passwords and force password change at next logon
  - Modify the membership of a group

### Account Lockout Policy Implementation

After noticing that accounts weren't locking after multiple failed attempts:

1. Opened Group Policy Management Editor
2. Edited Default Domain Policy → Computer Configuration → Policies → Windows Settings → Security Settings → Account Policies
3. Set the following account lockout policies:
   - Account lockout duration: 30 minutes
   - Account lockout threshold: 5 invalid logon attempts
   - Reset account lockout counter after: 30 minutes

### Password and Account Policy Enhancement

Implemented enterprise-grade password policies:

- Enforce password history: 16 passwords remembered
- Maximum password age: 60 days
- Minimum password age: 1 day
- Minimum password length: 12 characters
- Password must meet complexity requirements: Enabled
- Store passwords using reversible encryption: Disabled

### Comprehensive Audit Policy

Enabled auditing for security events:

- Audit logon events: Success and Failure
- Audit account management: Success and Failure
- Audit account logon events: Success and Failure
- Audit policy change: Success and Failure
- Audit directory service access: Success and Failure
- Audit privilege use: Success and Failure
- Audit system events: Success and Failure
- Audit process tracking: Success and Failure
- Audit object access: Success and Failure

### Security Options Enhancement

- Disabled Guest account
- Enabled "Limit local account use of blank passwords to console logon only"

## May 10: Tiered Access Model Implementation

### Tiered Access Model Planning

Created a three-tier administrative model:

1. **Tier 3 (User Tier):**

   - Regular Domain Users
   - Access only to WIN10-VULN and other user workstations
   - No administrative tools or permissions

2. **Tier 2 (Help Desk Tier):**

   - Help Desk group members
   - Access to IT Workstation with limited administrative tools
   - Delegated permissions for common support tasks

3. **Tier 1 (Administrative Tier):**
   - System Administrators group
   - Full access to IT Workstation and administrative tools
   - Access to domain controllers and servers

### Tier-Specific Group Policy Implementation

#### Tier 1 Administrative GPO Configuration

- **PowerShell Execution Policy:**

  - Enabled script execution (local and remote signed)
  - Enabled PowerShell Script Block Logging
  - Enabled PowerShell Transcription

- **Administrative Tools Access:**

  - Configured AppLocker rules for Tier1-Admins
  - Allowed installation of RSAT tools directly from Windows Update

- **Security and Audit Policy Access:**

  - Added Tier1-Admins to "Manage auditing and security log" and "Generate security audits"

- **Group Policy Management Access:**
  - Delegated full control via Delegation of Control Wizard

#### Tier 2 Help Desk GPO Configuration

- **PowerShell Execution Policy:**

  - Set to "Allow local scripts and remote signed scripts"

- **Administrative Tools Access:**

  - Created rules allowing specific tools (dsa.msc, printmanagement.msc, etc.)

- **RSAT Component Installation:**

  - Enabled downloading components from Windows Update

- **Group Policy Management Access:**
  - Delegated "Read" permissions only

### User Account Creation

Created test user accounts:

- IT Workstation: Jimmy Jazz (JJazz@lab.local, password: JJ@zz!-Worker!)
- SOC Workstation: Scally Wag (SWag@lab.local, password: SW@g!-Worker!)
- Service Accounts: spfarm, spadmin for SharePoint services

## Key Learning Moments

- Computer objects vs. user accounts: Permissions should be granted to users/groups, not computer objects
- Domain vs. local accounts: Best practice is to use domain accounts (LAB\username) rather than local accounts
- For file sharing permissions, both NTFS and SMB permissions must be properly configured
- Tiered access model creates security boundaries that limit lateral movement in case of compromise
