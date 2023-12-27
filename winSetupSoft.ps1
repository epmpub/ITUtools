$ProgressPreference = 'SilentlyContinue'

Invoke-WebRequest -Uri http://utools.run/winSoft.json -OutFile .\softwareList.json
$softList = Get-Content -Raw .\softwareList.json | ConvertFrom-Json

foreach ($item in $softList) {
    Start-Process -FilePath $env:ComSpec -ArgumentList "/c",$item.command -Wait -NoNewWindow
}
