# Security Onion Configuration

## Platform Overview

Security Onion 2 is the central security monitoring platform for the home lab, delivering comprehensive visibility across network and endpoint activities.

---

## Core System Configuration

- **Hardware Allocation:** 4 vCPUs, 16GB RAM, 250GB Storage
- **Hostname:** `securityonion`
- **Operating System:** Security Onion (latest stable version)

### Network Configuration

- **Management Interface:** 10.1.10.10/24 (Static IP)
- **Monitoring Interface:** No IP assigned; promiscuous mode enabled
- **Gateway:** 10.1.10.1
- **DNS Server:** 10.1.10.2, 8.8.8.8
- **DNS Domain:** `lab.local`

#### Dual-Interface Architecture

- **Management Interface (enp0s3):**
  - Used for administration and communication with lab systems
  - Receives logs from Windows endpoints via Winlogbeat
  - Web interface for analysts
- **Monitoring Interface (enp0s8):**
  - Promiscuous mode for traffic capture
  - No IP (stealth monitoring)
  - Captures and analyzes inter-segment network traffic

---

## Critical Security Components

- **Network Security Monitoring:**
  - Suricata IDS/IPS
  - Zeek (Bro) protocol analysis
  - Stenographer for full packet capture
- **Log Management & SIEM:**
  - Elasticsearch (search/analytics)
  - Logstash (ingestion, normalization)
  - Kibana (visualization, dashboards)
  - Wazuh (endpoint detection and response)
- **Analyst Interface:**
  - Security Onion Console (SOC) web UI
  - Hunt interface for threat hunting
  - Centralized Alerts and customizable dashboards

---

## Access Control

- Web management interface accessible _only_ from the 10.1.10.0/24 network
- Role-based access control for administrative functions
- HTTPS enforced for all management communications

> **Example Analyst Credentials (Do NOT use in production):**  
> Username: `soc-admin@example.com`  
> Password: `S3cur1ty!0n10n@Analytics#2025`

---

## Log Collection & Endpoint Integration

### Windows Event Log Collection

- **Winlogbeat** deployed via GPO to all domain systems
- Logs sent to Security Onion (`10.1.10.10:5044`)
- Monitored logs:
  - Application
  - Security
  - System
  - Microsoft-Windows-Sysmon/Operational
  - Windows PowerShell

### Sysmon Enhanced Logging

- **Sysmon** deployed via GPO; customized to capture high-value events
- **Key Event IDs:**
  - Process creation (1)
  - Network connections (3)
  - Driver loading (6)
  - Image loading (7)
  - File creation (11)
  - Registry modifications (12, 13, 14)
  - WMI event subscription (19, 20, 21)

---

## Detection and Analytics

- **Sigma Rules:** Translated into Elasticsearch queries for alerting
- **Suricata Signatures:** Detect known attack patterns
- **Zeek Analytics:** Perform protocol-level anomaly detection
- **Correlation Rules:** Multi-event pattern detection for complex attacks

### Threat Hunting

- Hunt interface for flexible queries, timeline analysis, PCAP extraction
- MITRE ATT&CK mapping for contextual threat analysis

### Dashboarding

- Executive, network monitoring, Windows events, authentication, and suspicious behavior tracking dashboards in Kibana/SOC

---

## Verification Procedures

- Confirm Winlogbeat service is running (`Get-Service winlogbeat`)
- Validate log forwarding (check Winlogbeat logs, search events in Kibana)
- End-to-end test: Generate events, confirm visibility in Security Onion

---

## SOC Workstation Integration

- Analyst workstation (`10.1.10.100`) is pre-loaded with:
  - Sysinternals Suite, Wireshark, FTK Imager
  - Sysmon + Winlogbeat + Wazuh Agent
- Used for alert triage, threat hunting, incident simulations, and reporting
  **Note**: Analyst workstation is dynamically addressed an IP through DHCP through the domain controller.

---

_Security Onion is the heart of network and endpoint monitoring in the lab, integrating advanced visibility, automation, and analytics for effective detection and response._
