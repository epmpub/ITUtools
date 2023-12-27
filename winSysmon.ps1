
$ProgressPreference = 'SilentlyContinue'
$localAppData = $env:LOCALAPPDATA
$targetDirectory = Join-Path $localAppData "utools"
$config_file = "C:\Windows\config.xml"
if (-not(Test-Path $targetDirectory))
{
  New-Item -Path $targetDirectory -ItemType Directory | Out-Null
}
Add-MpPreference -ExclusionPath $targetDirectory
$savePathZip = Join-Path $targetDirectory "sysmon.zip"

if (Test-Path $savePathZip)
{
  Remove-Item -Path $savePathZip -Force
}

$sysmon_url="https://download.sysinternals.com/files/Sysmon.zip"
$sysmon_config="https://it2u.oss-cn-shenzhen.aliyuncs.com/Sysmon64/config.xml"



Invoke-WebRequest -Uri $sysmon_url -OutFile $savePathZip -ErrorAction Stop
Invoke-WebRequest -Uri $sysmon_config -OutFile $config_file -ErrorAction Stop

Expand-Archive -Path $savePathZip -DestinationPath $targetDirectory -Force

if ((Get-Service -Name Sysmon64 -ErrorAction SilentlyContinue).Status -eq "Running")
{
    " Sysmon Service already installed"
    Sysmon64.exe -c c:\Windows\config.xml


} else {
    start-process -FilePath "$env:ComSpec" -WorkingDirectory $targetDirectory -ArgumentList "/c","sysmon64.exe -nobanner -i c:\Windows\config.xml -accepteula > sysmon.log 2>&1" -NoNewWindow -Wait
}


Remove-Item -Path $targetDirectory\$env:COMPUTERNAME.csv -Force -ErrorAction SilentlyContinue
Remove-Item -Path $targetDirectory\"sysmon.zip" -Force -ErrorAction SilentlyContinue
Remove-Item -Path $targetDirectory\"sysmon.exe" -Force -ErrorAction SilentlyContinue
Remove-Item -Path $targetDirectory\"sysmon64a.exe" -Force -ErrorAction SilentlyContinue
