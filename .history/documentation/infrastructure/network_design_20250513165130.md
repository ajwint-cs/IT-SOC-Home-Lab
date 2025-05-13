# Network Design

## Network Topology Overview

The lab consists of three isolated network segments designed to simulate different security zones in an enterprise environment:

[ External Network (Internet) ]
|
| (WAN: 203.0.113.15/24)
|
[ pfSense Firewall ]
|
|\***\*\*\*\*\*\*\***\_\***\*\*\*\*\*\*\***
| | |
| (LAN: 10.1.10.1/24)| (DMZ: 172.16.30.1/24)
| | |
[ SOC Network ] [ DMZ Network ] [ Malware Analysis Network ]
10.1.10.0/24 172.16.30.0/24 10.2.20.0/24

## Network Segmentation and Security Controls

### 1. SOC/IT Environment (10.1.10.0/24)

**Purpose**: Primary security operations and IT administration

**Security Controls**:

- Full outbound internet access for updates and threat intelligence
- Restricted inbound traffic (only from management interfaces)
- Full access to DNS services via Domain Controller
- Internal traffic monitoring via Security Onion

**Key Components**:

- Domain Controller (10.1.10.2): Windows Server 2022 providing Active Directory services
- SOC Workstation (10.1.10.100): Windows 10 Pro analyst workstation
- Security Onion (10.1.10.10): Security monitoring platform
- IT Workstation (10.1.10.101): Windows 10 Pro IT administration system
- SRV-PRINT-TICKET (10.1.10.20): Print services and ticketing system
- SRV-FILE-SHAREPOINT (10.1.10.21): File sharing and SharePoint services
- SRV-WSUS-RDP (10.1.10.22): Windows Server Update Services and remote desktop access
- WIN10-VULN (10.1.10.102): Vulnerable Windows 10 workstation for endpoint security and help desk scenarios

### 2. Malware Analysis Network (10.2.20.0/24)

**Purpose**: Isolated environment for analyzing malicious software

**Security Controls**:

- No direct internet access to prevent malware exfiltration
- Simulated internet services via REMnux INetSim
- Completely segregated from production SOC network
- Monitored by Security Onion for additional visibility

**Key Components**:

- REMnux (10.2.20.2): Linux-based malware analysis platform
- FlareVM (10.2.20.3): Windows-based malware analysis platform

### 3. DMZ Network (172.16.30.0/24)

**Purpose**: Future expansion for internet-facing services

**Security Controls**:

- Limited communication with SOC network
- Controlled access to internet
- Separate firewall rule set
- Monitored by Security Onion

**Key Components**:

- Reserved for future implementation

## Network Communication Flows

### Internal SOC Network Communication

**Domain-joined devices ↔ Domain Controller**:

- Authentication requests
- DNS resolution
- Group Policy updates

**All devices ↔ Security Onion**:

- Log forwarding (Winlogbeat)
- Security telemetry (Sysmon)
- Network traffic (mirrored ports)

### Cross-Network Communication

**SOC Network ↔ Malware Analysis Network**:

- Controlled file transfers via secure shared folder
- No direct network communication
- One-way traffic flow (SOC to Malware Lab)

### Internet Access

**SOC Network → Internet**:

- Full access through pfSense (NAT)
- Controlled by firewall rules

**Malware Analysis Network → Internet**:

- No direct access
- Simulated internet via INetSim
- Any required external files must pass through the secure transfer mechanism

## Data Transfer Controls

The lab implements a secure transfer mechanism for safely moving malware samples between environments:

[ Host System (Ubuntu Linux) ]
|
[ Secure Shared Folder ("/mnt/CySec Lab/Malware Samples") ]
|
[ noexec,nosuid,nodev,nofail mount protection ]
|
[ Controlled Transfer Only ]
|
[ Analysis VMs ]

**Security Measures**:

- Mount Options: The shared folder uses noexec, nosuid, and nodev mount options to prevent execution of malware on the host system
- Workflow: Samples must be copied to local VM directories before analysis
- Access Control: Limited group permissions prevent unauthorized access

## Future Expansion Capabilities

The lab architecture supports several expansion options:

### Additional Security Tools

- Vulnerability scanners (e.g., OpenVAS) on dedicated VM
- Honeypot systems in DMZ network
- Dedicated DFIR toolkit VM

### Monitoring Enhancements

- Network traffic analysis sensors
- Additional logging capabilities
- Visualization dashboards

### Training Environment

- Vulnerable systems for controlled penetration testing
- Threat hunting scenarios
- Red vs. blue team exercises

### IT Infrastructure Expansion

- File Server functionality for document management and sharing
- Print Server simulation for enterprise print queue management
- Certificate Authority services for internal PKI implementation
- WSUS (Windows Server Update Services) for patch management simulation
- Microsoft Exchange or other mail server for email workflow testing
- SharePoint or document management system for collaboration simulation
- Backup infrastructure with rotating schedules and retention policies

### Network Services Enhancement

- RADIUS server for network authentication
- Enterprise Wi-Fi simulation with 802.1X authentication
- Network monitoring tools (like Nagios or Zabbix)
- Network automation with Ansible or similar tools
- Software-defined networking experiments

### DevOps Integration

- Continuous Integration/Continuous Deployment (CI/CD) pipeline
- Configuration management tools (Puppet, Chef, Ansible)
- Containerization with Docker on Windows Server
- Infrastructure as Code implementation with Terraform
