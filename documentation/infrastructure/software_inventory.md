# Software Inventory

This document catalogs the primary software components used throughout the IT-SOC Home Lab environment. The software is organized by functional area to facilitate setup and maintenance.

## Network Infrastructure

### pfSense Firewall

- **Version**: 2.7.0 (latest stable)
- **Purpose**: Network segmentation, routing, and security controls
- **Key Features**:
  - Zone-based firewall rules
  - Network address translation (NAT)
  - VPN capabilities
  - Intrusion detection system
  - Traffic shaping and bandwidth management

## Security Monitoring

### Security Onion

- **Version**: 2.4.0 (latest stable)
- **Purpose**: Comprehensive security monitoring platform
- **Components**:
  - Suricata - Network IDS/IPS
  - Zeek - Network security monitoring
  - Elasticsearch - Data storage and analytics
  - Kibana - Data visualization
  - Wazuh - Host-based IDS/HIDS
  - TheHive/Cortex - SOAR platform integration
  - Fleet - Endpoint monitoring

## Domain Infrastructure

### Windows Server 2022

- **Purpose**: Domain controller, authentication, and directory services
- **Roles & Features**:
  - Active Directory Domain Services
  - DNS Server
  - Group Policy Management
  - Certificate Services

## Workstations

### SOC Analyst Workstation (Windows 10 Pro)

- **Purpose**: Security operations and analysis
- **Installed Tools**:
  - Security Onion Console (web interface)
  - Wireshark
  - Sysmon
  - Sysinternals Suite
  - PowerShell 7
  - Windows Terminal
  - VSCode
  - Chrome/Firefox with security extensions

### IT Administration Workstation (Windows 10 Pro)

- **Purpose**: System administration and management
- **Installed Tools**:
  - Active Directory Administration Tools
  - Group Policy Management Console
  - Remote Server Administration Tools (RSAT)
  - PowerShell 7
  - Windows Terminal
  - VSCode

### Vulnerable Workstation (Windows 10)

- **Purpose**: Testing and training scenarios
- **Characteristics**:
  - Outdated/missing security patches
  - Misconfigured security settings
  - Simulated user activity
  - Training data for security scenarios

## Malware Analysis Environment

### REMnux

- **Version**: 7.0 (latest stable)
- **Purpose**: Linux-based malware analysis
- **Key Tools**:
  - INetSim - Internet service simulation
  - Static analysis tools
  - Network traffic analysis tools
  - Forensic utilities
  - Deobfuscation tools

### FlareVM

- **Version**: Latest community release
- **Purpose**: Windows-based malware analysis
- **Key Tools**:
  - Ghidra
  - IDA Free
  - x64dbg/x32dbg
  - PE Explorer
  - Process Monitor/Explorer
  - RegShot
  - WinDbg

## Server Infrastructure

### Print and Ticketing Server

- **OS**: Windows Server 2022
- **Services**:
  - Print Server role
  - OTRS or osTicket for ticketing

### File and SharePoint Server

- **OS**: Windows Server 2022
- **Services**:
  - File Server role
  - SharePoint Server 2019 or SharePoint Foundation

### WSUS and RDP Server

- **OS**: Windows Server 2022
- **Services**:
  - Windows Server Update Services
  - Remote Desktop Session Host
  - Remote Desktop Gateway

## Endpoint Security and Monitoring

### All Windows Systems

- **Security Tools**:
  - Microsoft Defender (default configuration)
  - Sysmon (configured with SwiftOnSecurity profile)
  - Winlogbeat (for log forwarding to Security Onion)
  - PowerShell logging and transcription

## Backup and Recovery

### Host System

- **Backup Solution**: Automated VM snapshots
- **Schedule**: Weekly full backups, daily incremental
- **Retention**: 30-day rolling window

## Documentation and Management Tools

- **Network Documentation**: Draw.io/diagrams.net
- **Password Management**: KeePass or Bitwarden
- **Knowledge Base**: OneNote or Confluence
- **Project Management**: Trello or Jira
