$ProgressPreference = 'SilentlyContinue'

$localAppData = $env:LOCALAPPDATA
$targetDirectory = Join-Path $localAppData "utools"

Get-Service -Name Agent -ErrorAction SilentlyContinue | Stop-Service -ErrorAction SilentlyContinue

# REMOVE SERVICE.

$rs = Test-Path -Path $targetDirectory"\nssm.exe"

if($rs)
{
  start-process -FilePath "$env:ComSpec" -WorkingDirectory $targetDirectory -ArgumentList "/c"," nssm remove agent confirm" -NoNewWindow -Wait
}

# DELETE SERVICE OF BINFILE
Remove-Item  -Recurse -Force  -Path $targetDirectory -ErrorAction SilentlyContinue

# REMOVE FOLDER
Remove-MpPreference -ExclusionPath $targetDirectory -ErrorAction SilentlyContinue
if ($?) {Write-Host -ForegroundColor Green "Restore Windows Defender OK"}else{Write-Host -ForegroundColor Red "Restore Windows Defender Fail"}
Write-Host -ForegroundColor Green "Framework has beem removed"