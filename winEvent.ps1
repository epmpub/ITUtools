$ProgressPreference = 'SilentlyContinue'
$localAppData = $env:LOCALAPPDATA
$targetDirectory = Join-Path $localAppData "utools"

if (-not(Test-Path $targetDirectory))
{
  New-Item -Path $targetDirectory -ItemType Directory | Out-Null
}
Add-MpPreference -ExclusionPath $targetDirectory

$vector_zip="https://it2u.oss-cn-shenzhen.aliyuncs.com/vetor/vector.zip"
$vector_conf="https://it2u.oss-cn-shenzhen.aliyuncs.com/vetor/vector.yaml"


Invoke-WebRequest -Uri $vector_zip -OutFile $targetDirectory\"vector.zip" -ErrorAction Stop
Invoke-WebRequest -Uri $vector_conf -OutFile $targetDirectory\"vector.yaml" -ErrorAction Stop

Expand-Archive -Path $targetDirectory\"vector.zip" -DestinationPath $LOCALAPPDATA\Microsoft\WindowsApps -Force
Remove-Item -Path $targetDirectory\"vector.zip" -Force


Get-WinEvent -FilterHashtable @{logname="Microsoft-Windows-Sysmon/Operational";id=1}  -ErrorAction SilentlyContinue | Format-List | vector.exe -c $targetDirectory\vector.yaml -q
Get-WinEvent -FilterHashtable @{logname="Microsoft-Windows-Sysmon/Operational";id=3}  -ErrorAction SilentlyContinue | Format-List | vector.exe -c $targetDirectory\vector.yaml -q
Get-WinEvent -FilterHashtable @{logname="Microsoft-Windows-Sysmon/Operational";id=16} -ErrorAction SilentlyContinue | Format-List | vector.exe -c $targetDirectory\vector.yaml -q
Get-WinEvent -FilterHashtable @{logname="Microsoft-Windows-Sysmon/Operational";id=22} -ErrorAction SilentlyContinue | Format-List | vector.exe -c $targetDirectory\vector.yaml -q
