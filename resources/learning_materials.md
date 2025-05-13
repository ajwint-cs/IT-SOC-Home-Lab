# Learning Materials

This document provides structured learning paths and hands-on exercises for developing skills using the IT-SOC Home Lab environment.

## SOC Analyst Learning Paths

### Beginner Level

#### Security Fundamentals

- Network security concepts and protocols
- Basic Windows security architecture and components
- Introduction to threat detection methodologies
- Security monitoring principles
- Common attack vectors and defense mechanisms

#### Security Monitoring Basics

- Understanding log sources and formats (Windows Event Logs, Sysmon, Network Logs)
- Basic alert triage methodology
- Using Security Onion console for daily monitoring
- Event correlation fundamentals
- Documentation practices for security incidents

### Intermediate Level

#### Threat Hunting Fundamentals

- Creating effective search queries in Kibana/Security Onion
- Understanding the MITRE ATT&CK framework for TTP mapping
- Baseline establishment and deviation analysis
- Hypothesis-driven hunting techniques
- Hunt for unusual PowerShell commands:
- Identify unusual network connections from internal hosts

#### Incident Response Procedures

- Alert validation techniques and false positive reduction
- Incident documentation best practices
- Containment and remediation procedures
- Timeline construction
- Evidence preservation methods
- Stakeholder communication strategies

### Advanced Level

#### Advanced Threat Detection

- Custom detection rule creation (Sigma, Suricata)
- Behavior-based detection strategies
- Advanced correlation techniques
- Low-signal detection methods
- Proactive threat modeling

#### Malware Analysis

- Static analysis fundamentals
- File hash generation and analysis
- String extraction and analysis
- PE file structure analysis
- Dynamic analysis in isolated environments
- System change monitoring
- Network activity analysis
- Memory forensics
- Indicator extraction and sharing
- Malware family categorization

## Technical Skill Development

### Sysmon Process Creation Analysis

- Track process creation chains to identify malicious activity
- Analyze command-line parameters for obfuscation techniques
- Correlate parent-child process relationships

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

### IT Administration Skills

- Active Directory Management
- User lifecycle management
- Organizational Unit (OU) design
- Group Policy implementation
- Security compliance validation
- IT Service Management
- Print services administration
- File sharing and SharePoint
- Windows Update and patch management
- Remote Desktop Services

## Hands-on Exercises

### Daily SOC Workflow Simulation

1. **Morning Log Review (30 minutes)**

- Access Security Onion Kibana interface (https://10.1.10.10)
- Execute daily searches for suspicious activities:
  ```
  agent.hostname:* AND event.module:sysmon AND event.action:"Process Create"
  host.name:DC01 AND winlog.event_id:4625
  suricata.alert.signature_id:*
  ```
- Document findings in standardized format using Security Onion case management

2. **Alert Triage Process (45 minutes)**

- Investigate high-priority Suricata alerts using Hunt interface
- Categorize alerts by MITRE ATT&CK tactics and techniques
- Perform initial investigation using Sysmon correlation:
  ```
  _id:"<alert_id>" AND winlog.event_id:1
  ```
- Evaluate whether alerts represent true positive or false positive situations

### Attack Simulation Scenarios

#### Phishing Campaign Simulation

1. Deploy simulated phishing email to lab users
2. Execute macro-enabled document on SOC workstation
3. Monitor initial compromise and lateral movement
4. Practice containment and eradication procedures

#### Lateral Movement Exercise

1. Simulate compromised workstation using Atomic Red Team
2. Track credential theft attempts
3. Monitor for suspicious connections to Domain Controller
4. Implement containment strategies using firewall rules

#### Data Exfiltration Detection

1. Simulate sensitive data gathering
2. Attempt exfiltration through various channels
3. Practice detection using network monitoring
4. Implement blocking mechanisms

### Malware Analysis Exercises

#### Static Analysis Workflow

1. Initial sample triage

- Securely transfer sample to analysis environment
- Generate file hash values
- Check hash reputation
- Extract strings and identify suspicious indicators

2. PE File analysis

- Examine file headers and sections
- Identify suspicious imports/exports
- Check for packers and obfuscation

3. Document analysis

- Extract and analyze macros
- Identify suspicious objects
- Analyze script obfuscation

#### Dynamic Analysis Execution

1. Controlled execution environment setup

- Take VM snapshot before analysis
- Configure network monitoring
- Start process monitoring tools

2. System change monitoring

- Document created/modified files
- Track registry modifications
- Identify persistence mechanisms

3. Network activity analysis

- Capture and analyze DNS queries
- Examine HTTP/HTTPS traffic patterns
- Identify C2 communication

## Documentation Practice

### Standardized Reporting Templates

- Incident Reports
- Executive summary for leadership
- Technical details for IT/security teams
- Timeline of events and response actions
- Recommendations for future prevention

- Threat Intelligence Briefs
- Adversary TTPs observed in lab exercises
- Indicators of compromise (IOCs)
- Detection recommendations
- Mitigation strategies

- Security Posture Assessments
- Environment security baseline status
- Vulnerability management metrics
- Security control effectiveness
- Remediation priorities and roadmap

### Documentation Workflow

1. Create detailed analysis notes during investigations
2. Translate technical findings into business impact
3. Develop concise executive summaries
4. Practice presenting findings to simulated stakeholders
