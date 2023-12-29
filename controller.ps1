$ProgressPreference = "SilentlyContinue"
#requires -runasadministrator 

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201  -ErrorAction SilentlyContinue -Force | Out-Null
Install-Module -Name powershell-yaml  -ErrorAction SilentlyContinue -Force | Out-Null

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

foreach ($root in $config)
{
    #Install software
    #Remove-LocalGroupMember -Group "Administrators" -Member Demo
    #Remove-LocalUser -Name Demo
    #Get-LocalUser
    #Get-LocalGroupMember Administrators

    # Temporary comment
    # foreach ($file in $root.files)
    # {
    #     Write-Host "processing --->" $file.name
    #     Get-File-Install($file)
    # }

    # manipulate localusers
    # add user
    foreach ($user in $root.users.add)
    {
        $Secure_String_Pwd = ConvertTo-SecureString $user.password -AsPlainText -Force
        Write-Host -BackgroundColor Blue  $user.name + $user.group + $user.password
        NewLocalAdmin -UserName $user.name -LocalGroup $user.group -Password $Secure_String_Pwd
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
        Rename-LocalUser -Name $user.name -NewName $user.newName -ErrorAction SilentlyContinue
    }
}