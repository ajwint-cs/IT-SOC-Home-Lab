# Active Directory Setup

## Overview

The Windows Server 2022 Domain Controller establishes the authentication foundation and administrative framework for the IT-SOC Home Lab. This guide details the configuration and policies that enable secure, robust domain services.

---

## System Configuration

- **Hardware Allocation:** 4 vCPUs, 8GB RAM, 100GB Storage
- **Operating System:** Windows Server 2022

### Network Configuration

- **Static IP:** 10.1.10.2/24
- **Gateway:** 10.1.10.1
- **DNS Configuration:**
  - Primary DNS: 127.0.0.1 (loopback)
  - Secondary DNS: 8.8.8.8

---

## Active Directory Implementation

- **Forest/Domain Structure:** Single domain (`lab.local`)
- **Functional Level:** Windows Server 2022
- **Administrative Accounts:** Segregated standard and privileged accounts for security
- **Directory Services Restore Mode:** Secured with a complex password

> **Example (Do NOT use in production):**  
> Username: `Administrator`  
> Password: `W1nd0ws!S3rv3r@D0m@in#2025!`

---

## Group Policy Implementation

- **Password Policy:** Enforces complexity and rotation schedules
- **Security Baseline:** Applies Windows security baseline policies throughout the domain
- **Auditing Policy:** Comprehensive Windows Event Auditing enabled on all endpoints
- **Software Deployment:** Automated deployment of security tools through GPOs

---

## DNS Services

- **DNS Zones:** Forward and reverse lookup zones for `lab.local`
- **DNS Forwarding:** External DNS queries forwarded to secure providers
- **DNS Security:** DNSSEC validation enabled for enhanced security

---

## Summary

The Domain Controller is central to secure, resilient identity management, policy enforcement, and DNS services in the lab. Careful segregation of administrative privilege, strong password enforcement, and extensive auditing bolster the security posture.
