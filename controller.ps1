$ProgressPreference = "SilentlyContinue"
#requires -runasadministrator 

function Install-Powershell-Module {
    param (
        [string] $uri,
        [string] $moduleName
    )
    begin{
        $ProgressPreference = "SilentlyContinue"
        Write-Host -ForegroundColor Green "-> download begin"
    }
    process {
        $zipFolder = join-path $env:LOCALAPPDATA temp
        $dstFolder = Join-Path $zipFolder $moduleName
        $srcPath = $dstFolder+".zip"
        Invoke-WebRequest -Uri $uri -OutFile $srcPath

        $modulePath = "C:\Program Files\WindowsPowerShell\Modules\"
        $moduleFolder = Join-Path $modulePath $moduleName
        Expand-Archive -Path $srcPath -DestinationPath $moduleFolder -Force

        Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
        Import-Module $moduleName -ErrorAction SilentlyContinue
    }
    end {
        Write-Host -ForegroundColor Green "-> work end"

    }
}


# JSON FILE CONFIG
# import required module
# 1.powershell-yaml

$json=Invoke-RestMethod utools.run/modules.json

foreach($item in $json.modules.module)
{
    if ((Get-Module).Name -match $item.moduleName)
    {
       Write-Host "The package :"$item.moduleName"has been installed!"
    }
    else
    {
        Install-Powershell-Module -uri $item.uri -moduleName $item.moduleName
    }
}


# YAML FILE CONFIG
$config = ConvertFrom-Yaml -Yaml (Invoke-RestMethod utools.run/config.yaml)
function Get-File-Install($file)
{
    # Prepare file store folder
    New-Item -ItemType Directory -Path $config.global.fileStore -ErrorAction SilentlyContinue | Out-Null

    Write-Host "Download ->" $file.name
    $dst = Join-Path $config.global.fileStore $file.name
    Write-Host "Save->"$dst
    Invoke-WebRequest -Uri $file.uri -OutFile $dst
    Start-Process -FilePath "$env:ComSpec" -WorkingDirectory $config.global.fileStore  -ArgumentList "/c",$file.setup -Wait -NoNewWindow
}
function NewLocalAdmin
{
    [CmdletBinding()]
    param (
        [string] $UserName,
        [string] $LocalGroup,
        [securestring] $Password
    )    
    begin {
    }    
    process {
        New-LocalUser "$UserName" -Password $Password -FullName "$UserName" -Description "Temporary local admin" -ErrorAction SilentlyContinue
        Write-Verbose "$UserName local user crated"
        Add-LocalGroupMember -Group $LocalGroup -Member $UserName -ErrorAction SilentlyContinue
        Write-Verbose "$UserName added to the local administrator group"
    }    
    end {
    }
}

function Add-Environment
{
    [CmdletBinding()]
    param (
        [string] $path_spec
    )    
    begin {
    }    
    process {
        $oldpath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
        $newpath = $path_spec+';'+ $oldpath
        [Environment]::SetEnvironmentVariable('Path', $newpath, 'Machine')
    }    
    end {
        Write-Host -ForegroundColor Green "***Environment Need to restart to effect.***"
    }
}

foreach ($root in $config)
{
    #Install software
    #Remove-LocalGroupMember -Group "Administrators" -Member Demo
    #Remove-LocalUser -Name Demo
    #Get-LocalUser
    #Get-LocalGroupMember Administrators

    # Temporary comment
    foreach ($file in $root.files)
    {
        Write-Host "processing --->" $file.name
        Get-File-Install($file)
    }

    # manipulate localusers
    # add user
    foreach ($user in $root.users.add)
    {
        $Secure_String_Pwd = ConvertTo-SecureString $user.password -AsPlainText -Force
        # Write-Host -BackgroundColor Blue  $user.name + $user.group + $user.password
        NewLocalAdmin -UserName $user.name -LocalGroup $user.group -Password $Secure_String_Pwd -ErrorAction SilentlyContinue 
        # Add-LocalGroupMember -Group $user.group -Member $user.name -ErrorAction SilentlyContinue
    }
    # delete user
    foreach ($user in $root.users.delete)
    {
        Remove-LocalUser -Name $user.name  -ErrorAction SilentlyContinue
    }
    # rename user
    foreach ($user in $root.users.rename)
    {
        Write-Host -ForegroundColor Green  $user.name + $user.newName
        Rename-LocalUser -Name $user.name -NewName $user.newName -ErrorAction SilentlyContinue
    }

    # manipulate services
    # add service
    foreach ($service in $root.services.add)
    {
        Write-Host -ForegroundColor Green "The service " $service.name " has been installed"
        New-Service -Name $service.name -BinaryPathName $service.binaryPathName -Description $service.description -StartupType $service.startupType -DisplayName $service.displayName -WhatIf

    }
    # remove service
    foreach ($service in $root.services.delete)
    {
        Write-Host -ForegroundColor Red "The service " $service.name " has been deleted"
    }

    # manipulate environment
    foreach ($environ in $root.environments.add)
    {
        Write-Host -ForegroundColor Red "The environ " $environ.name " has been added"
        Add-Environment($environ.name)

    }

    foreach ($environ in $root.environments.delete)
    {
        Write-Host -ForegroundColor Red "The environ " $environ.name " has been deleted"
    }

    # manipulate script powershell
    foreach ($ps1 in $config.scripts.powershell)
    {
        Write-Host -ForegroundColor Green "Process Powershell" $ps1.name
        Invoke-RestMethod $ps1.uri | Invoke-Expression
    }

    # manipulate batch script
    foreach ($bat in $config.scripts.bat)
    {
        Write-Host -ForegroundColor Green "Process batch script" $bat.name 
        Invoke-RestMethod $bat.uri | Invoke-Expression
    }

    # manipulate python script
    foreach ($py in $config.scripts.python)
    {
        Write-Host -ForegroundColor Green "Process python script" $py.name 
        Invoke-RestMethod $py.uri | c:\\python311\python.exe
    }

    # manipulate cmd.exe command
    foreach ($c in $config.shell.cmd)
    {
        Write-Host -ForegroundColor Green "Process cmd.exe cmd" $c.name 
        Invoke-Expression -Command $c.commandLine
    }
    # manipulate powershell command
    foreach ($ps in $config.shell.powershell)
    {
        Write-Host -ForegroundColor Green "Process powershell cmd" $ps.name 
        Invoke-Expression -Command $ps.commandLine
    }




}