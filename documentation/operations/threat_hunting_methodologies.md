# Threat Hunting Methodologies

This document outlines the threat hunting methodologies and practices implemented in the lab environment to proactively identify malicious activities.

## Threat Hunting Approach

The lab implements the following structured threat hunting approach:

### Hypothesis Formation

- Develop hunting hypothesis based on threat intelligence
- Identify relevant data sources and artifacts
- Create search queries targeting specific TTPs

### Data Collection & Analysis

- Execute searches across Security Onion datasets
- Examine anomalous patterns and deviations
- Correlate findings across multiple data sources

### Documentation & Feedback Loop

- Document all findings regardless of outcome
- Update detection rules based on successful hunts
- Refine hypothesis for future hunting sessions

## Threat Hunting Exercises (60 minutes)

### PowerShell Command Hunting

- Develop hypothesis-based searches for specific adversary techniques
- Hunt for unusual PowerShell commands: `winlog.channel:"Microsoft-Windows-PowerShell/Operational" AND message:"-enc" OR message:"hidden" OR message:"bypass"`
- Identify unusual network connections from internal hosts
- Document findings regardless of outcome, updating detection rules as appropriate

### Process Creation Analysis

- Track process creation chains to identify malicious activity
- Example hunting query: `event.module:sysmon AND event.action:"Process Create" AND process.parent.name:winword.exe`
- Analyze command-line parameters for obfuscation techniques
- Correlate parent-child process relationships

## Hunting Methodologies

### Structured Analytics

1. **IOC Search**: Search for known indicators across network and host data: `destination.ip:203.0.113.100 OR url.domain:"malicious-domain.com"`
2. **TTP Hunt**: Identify behaviors matching known adversary techniques: `process.name:rundll32.exe AND NOT process.parent.name:explorer.exe`
3. **Anomaly Detection**: Find statistical outliers in normal behavior patterns: `source.bytes:>1000000 AND destination.port:53`

### MITRE ATT&CK Framework Integration

- Organize hunts by MITRE ATT&CK tactics and techniques
- Focus on high-impact techniques with low detection coverage
- Document findings using standardized MITRE technique IDs
- Example: Hunt for T1053.005 (Scheduled Task)
- `event.code:4698 OR process.name:schtasks.exe`

## Hunt Data Sources

### Network Data

- Zeek connection logs
- Suricata alerts
- DNS queries and responses
- HTTP/TLS transactions
- NetFlow data

### Endpoint Data

- Windows Event Logs
- Sysmon events
- PowerShell script block logging
- Authentication events
- Process creation logs

## Hunt Case Management

### Documentation Template

- **Hunt ID**: Unique identifier
- **Hypothesis**: What you're looking for and why
- **TTP Reference**: MITRE ATT&CK or other framework reference
- **Data Sources**: Systems and log types analyzed
- **Query**: The actual search syntax used
- **Results**: Summary of findings (positive or negative)
- **Detection Opportunities**: Suggestions for automated detection
- **Next Steps**: Follow-up actions or related hunts

### Outcomes Processing

1. **True Positive**: Document IOCs, create new detection rules
2. **False Positive**: Document the pattern to avoid future false alarms
3. **No Findings**: Document the approach for future reference
4. **New Hypothesis**: Create follow-up hunt based on current findings

## Scheduled Hunt Program

The lab implements a systematic hunt schedule:

1. **Daily Quick Hunts**: 15-30 minute focused searches for high-risk TTPs
2. **Weekly Deep Dives**: 2-hour comprehensive analysis of a specific technique
3. **Monthly Baseline**: Full review of environment to identify changes

## Skill Development Focus Areas

- Behavioral analysis through Windows event correlation
- Network protocol analysis using Zeek logs
- Statistical analysis for anomaly detection
- Timeline reconstruction techniques
- Advanced query development in Elasticsearch
