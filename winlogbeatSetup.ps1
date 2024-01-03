$ProgressPreference = 'SilentlyContinue'
$package="https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-8.11.3-windows-x86_64.zip"
# You should repalce you ** ES IP ADDRESS ** on the Prodcutin envoriment.
$config_file="https://it2u.oss-cn-shenzhen.aliyuncs.com/config/winlogbeat.yml"

Invoke-WebRequest -Uri $package -OutFile $env:LOCALAPPDATA"\winlogbeat-8.11.3-windows-x86_64.zip"
Invoke-WebRequest -Uri $config_file -OutFile $env:LOCALAPPDATA\"winlogbeat.yml"
Expand-Archive -Path $env:LOCALAPPDATA"\winlogbeat-8.11.3-windows-x86_64.zip" -DestinationPath $env:LOCALAPPDATA -Force

Move-Item -Path $env:LOCALAPPDATA"\winlogbeat.yml" -Destination $env:LOCALAPPDATA"\winlogbeat-8.11.3-windows-x86_64\" -Force

Set-ExecutionPolicy -Scope Process Bypass -Force
Invoke-Expression  $env:LOCALAPPDATA"\winlogbeat-8.11.3-windows-x86_64\install-service-winlogbeat.ps1"
Get-Service -Name winlogbeat | Start-Service
Remove-Item -Path $env:LOCALAPPDATA"\winlogbeat-8.11.3-windows-x86_64.zip" -Force


