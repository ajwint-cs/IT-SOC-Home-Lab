# Network Configuration Activities

## May 5: Network Fundamentals and NAT Setup

### Understanding Network Fundamentals

I spent time studying the concepts of multiplexing and demultiplexing:

- **Multiplexing**: Directs outgoing traffic to correct service using ports
- **Demultiplexing**: Delivers incoming traffic to correct service based on port number

### Socket vs. Port Understanding

Gained important insight: A socket is an active endpoint (IP + port), and it requires a running program to respond. A port is simply a virtual identifier for services.

### pfSense NAT Configuration

1. Configured Outbound NAT:

   - Logged into pfSense's web UI (https://10.1.10.124)
   - Navigated to Firewall → NAT → Outbound
   - Switched from "Automatic" to "Hybrid Outbound NAT" for more control
   - Created new NAT rule:
     - Interface: WAN
     - Source: Network 10.1.10.0/24 (SOC/IT subnet)
     - Source Port: any
     - Destination: any
     - NAT Address: Interface address

2. Verified Internet Access:
   - On the IT workstation (10.1.10.101), confirmed connectivity:
     `ping 8.8.8.8`
     `curl ifconfig.me`
     - Checked pfSense Diagnostics in 'States' to verify translation:

- Workstation (10.1.10.101) successfully using pfSense WAN IP for outbound connections

## May 6: DHCP Implementation

### DHCP Server Setup on Domain Controller

1. Added DHCP Server role to Windows Server 2022 Domain Controller
2. Completed DHCP Post-Install configuration wizard:

- Created security groups for DHCP administration
- Authorized DHCP server in the domain

### DHCP Configuration

1. Created IP scope with:

- Range: 10.1.10.100 - 10.1.10.200
- Subnet: 10.1.10.0/24
- No exclusions needed (servers using addresses below .100)

2. Configured DHCP options:

- Router: 10.1.10.1
- Parent domain: lab.local
- DNS Servers:
  - 10.1.10.2
  - 8.8.8.8
- Lease duration: 8 days (medium lease)

3. Updated workstations to use DHCP:

- Changed IPv4 settings to "Obtain an IP address automatically"
- Verified successful DHCP assignment and internet access

### Network Segmentation Implementation

Successfully established three distinct network segments:

- SOC/IT Network (10.1.10.0/24) - Primary security operations and IT administration
- DMZ Network (172.16.30.0/24) - Reserved for future internet-facing services
- Malware Analysis Network (10.2.20.0/24) - Completely air-gapped for malware analysis

## Key Learning Moments

- Socket vs. Port distinction: A socket is an active endpoint requiring a running program, while a port is just a virtual identifier
- For proper network isolation, both firewall rules and physical network separation are necessary
- DHCP lease time considerations: Shorter leases increase DHCP traffic while longer leases delay reclaiming unused addresses
- The Malware Analysis Network needs complete air-gap implementation to prevent malware exfiltration
