function clear-all-event-logs ()
{
   $logs = Get-EventLog  -List | ForEach-Object {$_.Log}
   $logs | ForEach-Object {Clear-EventLog -LogName $_ }
   Get-EventLog -list
}

clear-all-event-logs

# Max(K) Retain OverflowAction        Entries Log
# ------ ------ --------------        ------- ---
# 15,168      0 OverwriteAsNeeded           0 Application
# 15,168      0 OverwriteAsNeeded           0 DFS Replication
# 512         7 OverwriteOlder              0 DxStudio
# 20,480      0 OverwriteAsNeeded           0 Hardware Events
# 512         7 OverwriteOlder              0 Internet Explorer
# 20,480      0 OverwriteAsNeeded           0 Key Management Service
# 16,384      0 OverwriteAsNeeded           0 Microsoft Office Diagnostics
# 16,384      0 OverwriteAsNeeded           0 Microsoft Office Sessions
# 30,016      0 OverwriteAsNeeded           1 Security
# 15,168      0 OverwriteAsNeeded           2 System
# 15,360      0 OverwriteAsNeeded           0 Windows PowerShell
