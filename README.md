# Correctional Facility Incident Response Toolkit

## Overview
A PowerShell-based incident response toolkit designed around a simulated correctional facility workstation security investigation.

The toolkit collects Windows system information, running processes, network connections, failed logon events, and local account information.

## Modules
1. System information collection
2. Running process collection
3. Network connection collection
4. Failed logon event collection
5. Local account and administrator audit
6. Automated incident summary

## Technologies
- PowerShell
- Windows Event Logs
- Windows Management Instrumentation (WMI/CIM)
- Windows networking cmdlets
- CSV evidence reporting

## Evidence Handling
Original collection reports are retained locally.
Sanitized sample reports are provided for public review.

## Limitations
- Collection does not independently establish malicious activity.
- A failed logon event does not prove an attack.
- Process and network information requires analyst interpretation.
- Results represent a personal Windows workstation, not an actual correctional facility.

## Disclaimer
This is an educational cybersecurity project developed on a personal Windows workstation using simulated correctional-facility scenarios. No actual facility systems or inmate information were accessed.