# PowerShell Function/Cmdlet to clear all of Logs
Function Clear-WinEvent {
    [CmdletBinding(SupportsShouldProcess = $True)]
    Param
    ([String]$LogName)
    Process {
        If ($PSCmdlet.ShouldProcess("$LogName", "Clear log file")) {
            [System.Diagnostics.Eventing.Reader.EventLogSession]::`
                GlobalSession.ClearLog("$LogName")
        }
    }
}
    
# Clear-Host
# $VictimLog = "Microsoft-Windows-Windows Firewall With Advanced Security/Firewall"
# Get-WinEvent -ListLog $VictimLog
# Clear-WinEvent -LogName $VictimLog
# Write-Host "`nAfter running Clear-WinEvent: Check RecordCount "
# Get-WinEvent -ListLog $VictimLog

Get-WinEvent -ListLog * | ForEach-Object {Clear-WinEvent -LogName $_.LogName}
