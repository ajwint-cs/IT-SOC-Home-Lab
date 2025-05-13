# pfSense Configuration

## Overview

The pfSense firewall serves as the security cornerstone of the lab environment, providing network segmentation, traffic filtering, and secure routing between isolated segments.

---

## System Resources

- **Hardware Allocation:** 2 vCPUs, 4GB RAM, 20GB Storage
- **Platform:** pfSense (latest stable version)

---

## Interface Configuration

- **WAN Interface (External):** 203.0.113.15/24
- **LAN Interface (SOC Network):** 10.1.10.1/24
- **DMZ Interface (Isolated Zone):** 172.16.30.1/24

---

## Security Controls Implementation

### Zone-Based Firewall Rules

- **SOC Network → Internet:** Allow (NAT enabled)
- **SOC Network → Malware Analysis Network:** Allow (with protocol restrictions)
- **Malware Analysis Network → Internet:** Block (complete isolation)
- **Malware Analysis Network → SOC Network:** Block (prevent lateral movement)
- **DMZ → SOC Network:** Block (prevent compromise risk)
- **Internet → All Internal Networks:** Block (default deny)

### Advanced Security Features

- **Intrusion Prevention:** Enabled, with Snort rules customized for lab traffic
- **DNS Filtering:** DNS queries routed through pfSense using category-based filtering
- **VPN Access:** OpenVPN server configured for secure remote management
- **Traffic Monitoring:** NetFlow data exported to Security Onion for advanced monitoring

---

## Network Segmentation Strategy

- **SOC/IT Network (10.1.10.0/24):**

  - Main environment for security operations and IT administration
  - Domain-joined Windows systems and security monitoring tools
  - Protected by firewall; controlled internet access

- **Malware Analysis Network (10.2.20.0/24):**

  - Air-gapped for malware analysis
  - No direct internet access to prevent exfiltration
  - Simulated internet provided by REMnux INetSim

- **DMZ Segment (172.16.30.0/24):**
  - Reserved for future internet-facing services
  - Enhanced controls to mitigate risk

---

## Summary

pfSense provides robust and flexible security for the lab, enabling both high-assurance isolation and granular access where required. Its integration with Security Onion ensures complete traffic visibility while platform features like OpenVPN, DNS filtering, and Snort contribute to defense-in-depth.
