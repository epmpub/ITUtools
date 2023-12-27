$ProgressPreference = 'SilentlyContinue'
$sshd_msi = "https://it2u.oss-cn-shenzhen.aliyuncs.com/utools/OpenSSH-Win64-v9.4.0.0.msi"
$ssh_config = "https://it2u.oss-cn-shenzhen.aliyuncs.com/config/administrators_authorized_keys"
$dst = Join-Path $env:ProgramData "\ssh\administrators_authorized_keys"

curl -Uri $sshd_msi -OutFile OpenSSH-Win64-v9.4.0.0.msi -ErrorAction SilentlyContinue 

msiexec /i OpenSSH-Win64-v9.4.0.0.msi /quiet 
Start-Sleep -Seconds 3 
curl -Uri $ssh_config -OutFile $dst
icacls.exe ""$env:ProgramData\ssh\administrators_authorized_keys"" /inheritance:r /grant ""Administrators:F"" /grant ""SYSTEM:F"" |Out-Null

Start-Sleep -Seconds 2
Get-Service -Name sshd|Start-Service
if ($?) {Write-Host -ForegroundColor Green " OpenSSH server Setting OK"}else{Write-Host -ForegroundColor Red "OpenSSH server Setting Fail"}
