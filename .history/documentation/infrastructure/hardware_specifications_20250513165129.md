# Hardware Specifications

## Host System Requirements

The lab environment is designed to run on a high-performance host system. The reference implementation uses:

- **CPU**: Ryzen 7 7700X
- **GPU**: RTX 4060ti
- **RAM**: 64GB

> **Note**: Your hardware allocation may vary based on your host PC and use case. You may be able to run more or fewer virtual machines simultaneously depending on your available resources. Feel free to adjust your setup to better fit your purposes.

## Virtual Machine Specifications

The following table outlines the hardware allocations for each component in the lab environment:

| Component           | IP Address                                                          | Network          | Hardware Allocation              | Purpose                                                          |
| ------------------- | ------------------------------------------------------------------- | ---------------- | -------------------------------- | ---------------------------------------------------------------- |
| pfSense Firewall    | 203.0.113.15/24 (WAN)<br>10.1.10.1/24 (LAN)<br>172.16.30.1/24 (DMZ) | Multiple         | 2 vCPUs, 4GB RAM, 20GB Storage   | Network segmentation, security controls, routing                 |
| Domain Controller   | 10.1.10.2/24                                                        | SOC/IT Network   | 4 vCPUs, 8GB RAM, 100GB Storage  | Active Directory, DNS, authentication                            |
| SOC Workstation     | 10.1.10.100/24                                                      | SOC Network      | 2 vCPUs, 4GB RAM, 80GB Storage   | Security analysis, incident response                             |
| Security Onion      | 10.1.10.10/24                                                       | SOC Network      | 4 vCPUs, 16GB RAM, 250GB Storage | Network monitoring, SIEM, IDS/IPS                                |
| IT Workstation      | 10.1.10.101/24                                                      | SOC/IT Network   | 2 vCPUs, 4GB RAM, 80GB Storage   | IT administration tasks                                          |
| SRV-PRINT-TICKET    | 10.1.10.20/24                                                       | SOC/IT Network   | 2 vCPUs, 4GB RAM, 60GB Storage   | Print services, ticketing system                                 |
| SRV-FILE-SHAREPOINT | 10.1.10.21/24                                                       | SOC/IT Network   | 4 vCPUs, 8GB RAM, 120GB Storage  | File sharing, SharePoint services                                |
| SRV-WSUS-RDP        | 10.1.10.22/24                                                       | SOC/IT Network   | 4 vCPUs, 4GB RAM, 150GB Storage  | Windows updates, remote desktop access                           |
| WIN10-VULN          | 10.1.10.102/24                                                      | SOC/IT Network   | 2 vCPUs, 4GB RAM, 80GB Storage   | Purposely vulnerable/misconfigured endpoint, help desk scenarios |
| REMnux              | 10.2.20.2/24                                                        | Malware Analysis | 4 vCPUs, 8GB RAM, 100GB Storage  | Static/network malware analysis                                  |
| FlareVM             | 10.2.20.3/24                                                        | Malware Analysis | 4 vCPUs, 8GB RAM, 150GB Storage  | Dynamic malware analysis                                         |

> **Note**: IP addresses are obfuscated as per Appendix A of the original documentation.

## Total Resource Requirements

The complete lab environment requires approximately:

- 32+ vCPUs
- 72+ GB RAM
- 1+ TB Storage
  **Note**: Typically, I do not run all of the virtual machines at once, I run them in groups. (Ex: pfSense, Domain Controller, IT Workstation, and SRV-PRINT-TICKET)

These resources can be adjusted based on which components you plan to run simultaneously. The lab design allows for components to be powered on only when needed, reducing the overall resource requirements during normal operation.
