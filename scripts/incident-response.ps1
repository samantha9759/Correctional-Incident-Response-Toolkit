Write-Host "Correctional Facility Incident Response Toolkit"
Write-Host "System Information Collection"

$Project = "$env:USERPROFILE\Desktop\Correctional-Incident-Response-Toolkit"
$Evidence = "$Project\evidence"

$OS = Get-CimInstance Win32_OperatingSystem

[PSCustomObject]@{
    CollectionTime = Get-Date
    ComputerName = $env:COMPUTERNAME
    CurrentUser = "$env:USERDOMAIN\$env:USERNAME"
    OperatingSystem = $OS.Caption
    OSVersion = $OS.Version
    LastBoot = $OS.LastBootUpTime
} | Export-Csv "$Evidence\System-Information.csv" -NoTypeInformation

Write-Host "System information collected."

# Module 2: Running Process Collection

Write-Host "Collecting running processes..."

$Processes = Get-Process |
Select-Object ProcessName, Id, CPU, StartTime, Path

$Processes |
Export-Csv "$Evidence\Running-Processes.csv" -NoTypeInformation

Write-Host "Running process collection complete."

# Module 3: Network Connection Collection

Write-Host "Collecting network connections..."

$NetworkConnections = Get-NetTCPConnection |
Select-Object LocalAddress, LocalPort, RemoteAddress,
RemotePort, State, OwningProcess

$NetworkConnections |
Export-Csv "$Evidence\Network-Connections.csv" -NoTypeInformation

Write-Host "Network connection collection complete."

# Module 4: Failed Logon Event Collection

Write-Host "Collecting failed logon events..."

$FailedLogons = Get-WinEvent -FilterHashtable @{
    LogName = 'Security'
    Id = 4625
} -MaxEvents 500 -ErrorAction SilentlyContinue

$FailedLogons |
Select-Object TimeCreated, Id, ProviderName, MachineName, Message |
Export-Csv "$Evidence\Failed-Logon-Events.csv" -NoTypeInformation

Write-Host "Failed logon events collected: $($FailedLogons.Count)"

# Module 5: Local Account Security Audit

Write-Host "Collecting local user accounts..."

$LocalUsers = Get-LocalUser |
Select-Object Name, Enabled, LastLogon, PasswordRequired, SID

$LocalUsers |
Export-Csv "$Evidence\Local-User-Accounts.csv" -NoTypeInformation

Write-Host "Collecting local administrators..."

$Administrators = Get-LocalGroupMember -Group "Administrators" |
Select-Object Name, ObjectClass, PrincipalSource, SID

$Administrators |
Export-Csv "$Evidence\Local-Administrators.csv" -NoTypeInformation

Write-Host "Account security audit complete."

# Module 6: Incident Summary

Write-Host "Generating incident summary..."

$Summary = @"
CORRECTIONAL FACILITY INCIDENT RESPONSE TOOLKIT
===============================================

Collection Date: $(Get-Date)
Computer: $env:COMPUTERNAME
User: $env:USERNAME

EVIDENCE COLLECTED
------------------
System Information
Running Processes
Network Connections
Failed Logon Events
Local User Accounts
Local Administrators

COLLECTION METHOD
-----------------
PowerShell read-only collection.

LIMITATIONS
-----------
Collected artifacts do not independently establish
who performed an action or whether malicious activity
occurred. Findings require further investigation.

"@

$Summary | Set-Content "$Project\reports\Incident-Summary.txt"

Write-Host "Incident summary generated."
