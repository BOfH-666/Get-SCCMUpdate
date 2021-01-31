$ScriptRoot  = Split-Path -Path $MyInvocation.MyCommand.Definition -parent
Update-TypeData -AppendPath $ScriptRoot\Get-SCCMUpdate.TypeData.ps1xml

<#
    .SYNOPSIS
        Gets updates available in SCCM Software Center on one or more specified computers.
    .DESCRIPTION
        The Get-SCCMUpdate cmdlet will list all in SCCM Software Center available updates for one or more specified computers.
    .PARAMETER  ComputerName
        One or more computernames
    .EXAMPLE
        PS C:\> Get-SCCMUpdate

        This will list all in SCCM Software Center available updates on the local computer.
    .EXAMPLE
        PS C:\> Get-SCCMUpdate -ComputerName 'RemoteComputer01','RemoteComputer02'

        This will list all in SCCM Software Center available updates for the specified remote computers.
    .EXAMPLE
        PS C:\> Get-ADComputer -Filter * -SearchBase 'OU=Berlin,OU=city,OU=Germany,OU=country,DC=contoso,DC=com' |
        >>> Select-Object -Property Name |
        >>> Get-SCCMUpdate

        This will list all in SCCM Software Center available updates for the computers received from the AD.
    .EXAMPLE
        PS C:\> $Cred = Get-Credential -UserName 'domain\DomainAdmin'
        PS C:\> Get-SCCMUpdate -ComputerName 'DC_01','DC_02' -Credential $Cred

        This will list all in SCCM Software Center available updates for both specified domain controllers.
    .INPUTS
        System.String, System.Management.Automation.PSCredential
    .OUTPUTS
        Microsoft.Management.Infrastructure.CimInstance#root/ccm/clientsdk/CCM_SoftwareUpdate
    .NOTES
        Author: O.Soyk
        Date:   20210120
#>
function Get-SCCMUpdate {
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Position = 0,
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Enter one or more computer names separated by comma.")]
        [ValidateNotNullOrEmpty()]
        [Alias("CN", "MachineName", "Name", "Hostname", "DNSHostName")]
        [System.String[]]
        $ComputerName = $ENV:COMPUTERNAME,
        [Parameter(Position = 1,
            Mandatory = $false,
            HelpMessage = "A credential object granting access to the targeted remote computer.")]
        [System.Management.Automation.PSCredential]
        $Credential
    )
    process {
        $ComputerNameList = $ComputerName
        foreach ($ComputerName in $ComputerNameList) {
            if (Test-Connection -ComputerName $ComputerName -Count 1 -TimeoutSeconds 1 -Quiet) {
                $NewCimSessionParams = @{
                    ComputerName = $ComputerName
                }
                if ($Credential) {
                    $NewCimSessionParams.Credential = $Credential
                }
                $CIMSession = New-CimSession @NewCimSessionParams
                try {
                    Get-CimInstance -ClassName 'CCM_SoftwareUpdate' -Namespace 'ROOT\ccm\ClientSDK' -CimSession $CIMSession 
                    Remove-CimSession -CimSession $CIMSession
                }
                catch {
                    throw $_
                }
            }
            Else {
                Write-Warning "'$($ComputerName)' unreachable"
            }
        }
    }
}