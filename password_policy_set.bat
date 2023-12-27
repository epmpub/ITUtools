@echo off
echo [version]>gp.inf
echo signature="$CHICAGO$">>gp.inf
echo [System Access]>>gp.inf
echo MinimumPasswordAge = 0 >>gp.inf
echo MaximumPasswordAge = 90 >>gp.inf
echo MinimumPasswordLength = 12 >>gp.inf
echo PasswordComplexity = 1 >>gp.inf
echo LockoutBadCount = 5 >>gp.inf
echo LockoutDuration = 30 >>gp.inf
echo PasswordHistorySize = 5  >>gp.inf
secedit /configure /db gp.sdb /cfg gp.inf
del /f /q gp.inf gp.sdb gp.jfm