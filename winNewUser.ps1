#Paolo Frigo, https://www.scriptinglibrary.com
#requires -runasadministrator 

function NewLocalAdmin {
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
#$NewLocalAdmin = Read-Host "New local admin username:"
#$Password = Read-Host -AsSecureString "Create a password for $NewLocalAdmin"
$NewLocalAdmin = "Demo"
$Secure_String_Pwd = ConvertTo-SecureString "Password!" -AsPlainText -Force
NewLocalAdmin -NewLocalAdmin $NewLocalAdmin -Password $Secure_String_Pwd

#Remove-LocalGroupMember -Group "Administrators" -Member ForTest
#Remove-LocalUser -Name ForTEST

#Get-LocalUser
#Get-LocalGroupMember Administrators
