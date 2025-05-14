# IT-SOC Home Lab

A comprehensive Security Operations Center (SOC) and IT administration home lab environment designed to simulate enterprise-level security monitoring, incident response, and system administration capabilities.

## Overview

This project documents the design, implementation, and operation of a sophisticated IT and security operations home lab. The lab simulates an enterprise environment with multiple network segments, security monitoring tools, and IT infrastructure services.

## Key Features

- Multi-segmented network architecture with pfSense firewall implementing defense-in-depth
- Windows Server 2022 Active Directory domain with Group Policy implementation
- Security Onion 2 deployment with Suricata, Zeek, Wazuh, and Elastic Stack
- Isolated malware analysis environment with REMnux and FlareVM
- IT service infrastructure including print services, file sharing, and Windows update management
- Comprehensive documentation of infrastructure, configurations, and operational procedures

## Lab Architecture

[External Network (Internet)]
|
| (WAN: 203.0.113.15/24)
|
[ pfSense Firewall ]
|
**\_\_**|**\*\***\*\***\*\***\_\_\_**\*\***\*\***\*\***
| | |
| (LAN: 10.1.10.1/24)| (DMZ: 172.16.30.1/24)  
 | | |
[ SOC Network ] [ DMZ Network ] [ Malware Analysis Network ]
10.1.10.0/24 172.16.30.0/24 10.2.20.0/24
|
|---- Domain Controller (10.1.10.2/24)
|---- Security Onion (10.1.10.10/24)
|---- SOC Workstation (10.1.10.100/24)
|---- IT Workstation (10.1.10.101/24)
|---- SRV-PRINT-TICKET (10.1.10.20/24)
|---- SRV-FILE-SHAREPOINT (10.1.10.21/24)
|---- SRV-WSUS-RDP (10.1.10.22/24)
|---- WIN10-VULN (10.1.10.102/24)

Air-gapped/Isolated:

- REMnux (10.2.20.2/24)
- FlareVM (10.2.20.3/24)

The lab consists of the following key components:

- Segmented network with DMZ, user, and server VLANs
- pfSense firewall providing network security and segmentation
- Windows Server 2022 domain controller
- Security Onion 2 for security monitoring and threat detection
- Malware analysis workstations in isolated environment
- Client machines for testing and user simulation

## Documentation Structure

- **Infrastructure**: Network design, hardware specifications, and software inventory
- **Implementation**: Step-by-step guides for setting up each component
- **Operations**: SOC workflows, incident response procedures, and threat hunting methodologies

## Skills Demonstrated

- Network security architecture and implementation
- Windows domain administration and Group Policy management
- Security monitoring and SIEM configuration
- Incident response and threat hunting
- Malware analysis techniques
- IT service management and automation

## Future Enhancements

- Implementation of cloud security monitoring
- Integration with threat intelligence platforms
- Expansion of automation capabilities
- Addition of vulnerability management tools

## Contact

(Linkedin)[https://www.linkedin.com/in/aj-in-cs/]
(Cover Letter)[swe-cover-letter.vercel.app]
