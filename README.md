# Get-SCCMUpdate
  
**.SYNOPSIS**  
Gets updates available in SCCM Software Center on one or more specified computers.  
**.DESCRIPTION**  
The Get-SCCMUpdate cmdlet will list all in SCCM Software Center available updates for one or more specified computers.  
**.PARAMETER  ComputerName**  
One or more computernames  
**.EXAMPLE**  

```Powershell
PS C:\> Get-SCCMUpdate
```
  
This will list all in SCCM Software Center available updates on the local computer.  
**.EXAMPLE**  

```Powershell
PS C:\> Get-SCCMUpdate -ComputerName 'RemoteComputer01','RemoteComputer02'
```
  
This will list all in SCCM Software Center available updates for the specified remote computers.  
**.EXAMPLE**  

```Powershell
PS C:\> Get-ADComputer -Filter * -SearchBase 'OU=Berlin,OU=city,OU=Germany,OU=country,DC=contoso,DC=com' |
>>> Select-Object -Property Name |
>>> Get-SCCMUpdate
```
  
This will list all in SCCM Software Center available updates for the computers received from the AD.  
**.EXAMPLE**  

```Powershell
PS C:\> $Cred = Get-Credential -UserName 'domain\DomainAdmin'
PS C:\> Get-SCCMUpdate -ComputerName 'DC_01','DC_02' -Credential $Cred
```
  
This will list all in SCCM Software Center available updates for both specified domain controllers.  
**.INPUTS**  
System.String, System.Management.Automation.PSCredential  
**.OUTPUTS**  
Microsoft.Management.Infrastructure.CimInstance#root/ccm/clientsdk/CCM_SoftwareUpdate  
**.NOTES**  
Author: O.Soyk  
Date:   20210120  
