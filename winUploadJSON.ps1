
Get-Process | Group-Object -Property Name | Sort-Object -Property Count -Descending | Select-Object Count, name | ConvertTo-Json | Invoke-RestMethod -Method Post -Uri http://utools.run/data -ContentType application/json
