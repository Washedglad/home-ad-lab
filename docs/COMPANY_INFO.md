# Goldshire Consulting - Lab Company Information

This document provides information about the fictional company used in this lab environment.

## Company Overview

**Company Name:** Goldshire Consulting  
**Industry:** IT Consulting and Cybersecurity Services  
**Domain:** goldshire.local  
**Website:** www.goldshire-consulting.goldshire.local (internal)

## Company Background

Goldshire Consulting is a fictional IT consulting company created for this Home AD Lab environment. The name is a playful reference to Goldshire, a location in World of Warcraft known for its... interesting chat.

## Lab Environment Details

### Network Information
- **Domain:** goldshire.local
- **Internal Network:** 192.168.100.0/24
- **DMZ Network:** 192.168.101.0/24
- **Company Website:** Hosted on WEB01 (192.168.101.10)

### Organizational Structure

**Departments:**

#### IT Department
- **Purpose:** Technology infrastructure and support
- **Users:** IT Administrator, IT Support, Network Administrator
- **Responsibilities:** Domain administration, network management, help desk support
- **Security Groups:** IT Department, Help Desk, Network Operators

#### Sales Department
- **Purpose:** Sales and customer relations
- **Users:** Sales Manager, Sales Representatives
- **Responsibilities:** Client management, sales operations
- **Security Groups:** Sales Department

#### HR Department
- **Purpose:** Human resources and employee management
- **Users:** HR Director, HR Assistant
- **Responsibilities:** Employee records, payroll, benefits
- **Security Groups:** HR Department, HR Admins
- **Note:** Contains sensitive PII/PHI data

#### Management
- **Purpose:** Executive leadership
- **Users:** CEO, CFO
- **Responsibilities:** Strategic planning, financial management
- **Security Groups:** Executives, Managers, Finance
- **Note:** High-value targets for APT simulation

#### Security Team
- **Purpose:** Cybersecurity monitoring and incident response
- **Users:** Security Analyst
- **Responsibilities:** SIEM monitoring, threat detection, incident response
- **Security Groups:** Security Team, Event Log Readers

#### Service Accounts
- **Purpose:** Application and service authentication
- **Accounts:** Web Service Account, Backup Service Account
- **Note:** Used for service account abuse scenarios

**Servers:**
- DC01 - Domain Controller (192.168.100.10)
- WEB01 - Web Server (192.168.101.10)
- Wazuh SIEM - Security Monitoring (192.168.100.20)

**Workstations:**
- CLIENT01 - General workstation (192.168.100.50)

**User Accounts:**
- See [LAB_USER_ACCOUNTS.md](./LAB_USER_ACCOUNTS.md) for complete user account list
- Total: 15 user accounts across all departments
- All accounts use intentionally weak passwords for cybersecurity training

## Using This Company in Labs

When creating:
- User accounts
- Email addresses
- Website content
- Documentation
- Test scenarios

Use "Goldshire Consulting" as the company name to maintain consistency throughout the lab environment.

## Website Content Ideas

For the web server, you could create:
- Employee portal
- Company intranet
- Service catalog
- IT support portal
- Company news and announcements

## Note

This is a fictional company created solely for lab and educational purposes. Any resemblance to real companies is purely coincidental.

