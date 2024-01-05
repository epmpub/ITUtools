# setting windows console encoding

if ((Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Command Processor\').autorun -eq "chcp 65001")
{
    Write-Host -BackgroundColor Green "Current setting is:UTF-8"
    $ret = Read-Host -Prompt "Rest to Default Setting?[y/n]"
    if($ret -eq 'y')
    {
        Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Command Processor\' -Name autorun -Force
        New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Command Processor\' -Name autorun -Type String -Value "chcp 936" -ErrorAction Stop | Out-Null
        Write-Host -BackgroundColor Red "Current setting is:ASNI"
        Start-Sleep -Seconds 2
    }
    else {
        "Bye"
    }

}
else
{
    Write-Host -BackgroundColor Green "Current setting is:ANSI"
    $ret = Read-Host -Prompt "Do you want to set UTF-8?[y/n]"
    if($ret -eq 'y')
    {
        Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Command Processor\' -Name autorun -Force
        New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Command Processor\' -Name autorun -Type String -Value "chcp 65001" -ErrorAction Stop | Out-Null
        Write-Host -BackgroundColor Red "Current setting is:UTF-8"
        Start-Sleep -Seconds 2


    }
    else {
        "Bye"
    }
}


# New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Command Processor\' -Name autorun -Type String -Value "chcp 65001"
# New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Command Processor\' -Name autorun -Type String -Value "chcp 936"
