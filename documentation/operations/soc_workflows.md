# SOC Workflows

This document outlines the standardized SOC analyst workflows implemented in the lab environment to ensure consistent security operations and skill development.

## Daily Operations Schedule

The lab environment implements a practice structured daily workflow for developing and maintaining critical security monitoring skills:

### Morning Routine (30 minutes)

- Review Security Onion dashboard for overnight alerts (15 minutes)
- Triage critical alerts using Sigma rules (15 minutes)
- Document any significant findings in incident tracking system

### Midday Activities (60 minutes)

- Conduct targeted threat hunting with Suricata/Zeek data (30 minutes)
- Investigate suspicious process creation events via Sysmon (15 minutes)
- Update detection rules based on findings (15 minutes)

### Afternoon Procedures (90 minutes)

- Execute incident simulation exercises using Atomic Red Team (45 minutes)
- Document findings and create comprehensive reports in Kibana (30 minutes)
- Review and improve SOAR playbooks in Shuffle (15 minutes)

## Typical Workflow Sequence

1. Log review in Security Onion Kibana (15 minutes)
2. Alert triage using Sigma rules
3. Threat hunting with Suricata/Sysmon data
4. Incident simulation using Atomic Red Team
5. Report writing in ELK dashboard

## Alert Triage Process

### Initial Assessment

- Evaluate alert severity and categorization
- Confirm affected systems and timeframe
- Determine if alert is part of a larger pattern

### Investigation

- Collect relevant logs from Security Onion (10.1.10.10)
- Analyze suspicious activity using Kibana hunt interface
- Correlate with Sysmon process creation events

### Containment & Documentation

- If malicious: isolate affected systems via firewall rules
- Document findings using standardized templates
- Escalate as needed according to severity matrix

## Essential Skills Development

The lab environment facilitates development of core SOC analyst capabilities:

### Sysmon Process Creation Analysis

- Track process creation chains to identify malicious activity
- Analyze command-line parameters for obfuscation techniques
- Correlate parent-child process relationships
- Example query: `event.module:sysmon AND event.action:"Process Create" AND process.parent.name:winword.exe`

### Network Traffic Investigation

- Analyze Suricata alerts for C2 traffic patterns
- Examine packet captures for malicious HTTP headers
- Identify DNS-based data exfiltration attempts
- Extract network IOCs from suspicious traffic

### SOAR Playbook Execution

- Implement Shuffle-based automation workflows
- Create conditional response actions based on alert types
- Integrate email notifications for critical incidents
- Document playbook effectiveness metrics

### Windows Event Log Analysis

- Identify suspicious logon patterns in Event ID 4624/4625
- Track privilege escalation via Event ID 4672
- Monitor service creation events (Event ID 7045)
- Detect lateral movement through event correlation

## Morning Log Review (30 minutes)

- Access Security Onion Kibana interface (https://10.1.10.10)
- Execute daily searches for suspicious activities: `agent.hostname:* AND event.module:sysmon AND event.action:"Process Create" host.name:DC01 AND winlog.event_id:4625 suricata.alert.signature_id:*`
- Document findings in standardized format using Security Onion case management

## Verification Procedures

To validate Security Onion functionality, the environment includes established testing processes:

### Verification Checklist

- Winlogbeat service status verification (PowerShell: `Get-Service winlogbeat`)
- Log forwarding confirmation (check Winlogbeat logs for errors)
- Security Onion data validation (search Kibana for hostname-specific events)
- End-to-end testing (generate test events, confirm appearance in Security Onion)
