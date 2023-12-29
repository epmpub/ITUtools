$ProgressPreference = "SilentlyContinue"
#requires -runasadministrator 

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201  -ErrorAction SilentlyContinue -Force | Out-Null
Install-Module -Name powershell-yaml  -ErrorAction SilentlyContinue -Force | Out-Null

$config = ConvertFrom-Yaml -Yaml (Invoke-RestMethod utools.run/config.yaml)


function Get-File($file)
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
        [string] $NewLocalAdmin,
        [securestring] $Password
    )    
    begin {
    }    
    process {
        New-LocalUser "$NewLocalAdmin" -Password $Password -FullName "$NewLocalAdmin" -Description "Temporary local admin" -ErrorAction SilentlyContinue
        Write-Verbose "$NewLocalAdmin local user crated"
        Add-LocalGroupMember -Group "Administrators" -Member "$NewLocalAdmin" -ErrorAction SilentlyContinue
        Write-Verbose "$NewLocalAdmin added to the local administrator group"
    }    
    end {
    }
}

$NewLocalAdmin = "Demo"
$Secure_String_Pwd = ConvertTo-SecureString "Password!" -AsPlainText -Force
NewLocalAdmin -NewLocalAdmin $NewLocalAdmin -Password $Secure_String_Pwd

#Remove-LocalGroupMember -Group "Administrators" -Member Demo
#Remove-LocalUser -Name Demo
#Get-LocalUser
#Get-LocalGroupMember Administrators






foreach ($root in $config)
{
    foreach ($file in $root.files)
    {
        Write-Host "processing --->" $file.name
        Get-File($file)
    }
}