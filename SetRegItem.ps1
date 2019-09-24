
# What to do if you encounter an error
$ErrorActionPreference = "silentlycontinue"

$OU = "OU=Test,DC=foo,DC=local"
$global:regPath = $null

# Get a list of comuters from Active Directory
Import-Module ActiveDirectory
$computers = (Get-ADComputer -Filter { (ObjectClass -eq "Computer") -and (Enabled -eq "True") } -SearchBase $OU -SearchScope Subtree | Select -Expand DNSHostName)

# change the registry key
function fRegSet($computer) {
       $regPath1=$global:regPath
       $val = Invoke-Command –ComputerName $computer –ScriptBlock { Get-ItemProperty -Path $Using:regPath1 -Name CryptoModuleTypeName}

       if($val.CryptoModuleTypeName -eq "aes256")
            {
            Write-Host $val.CryptoModuleTypeName " registry alredy right " -ForeGroundColor Cyan
            }
       elseif($val.CryptoModuleTypeName -eq $null) 
            {
            Write-Host "registry key Does Not Exist " -ForeGroundColor Magenta
            }
       else
            { 
            Invoke-Command –ComputerName $computer –ScriptBlock { Set-ItemProperty -Path $Using:regPath -Name CryptoModuleTypeName -value 'aes256'}
            Write-Host $val.CryptoModuleTypeName " registry key Set aes256" -ForeGroundColor Green
            }
}

foreach ($computer in $computers) {
    
    # if online
    if (Test-Connection -ComputerName $computer -Quiet -count 1) 
    {
        $CompArch = (Get-WmiObject Win32_OperatingSystem -computername $computer).OSArchitecture
        if ($CompArch -eq "32-bit") 
            {
            Write-Host $computer "32-bit"
            $global:regPath = 'HKLM:\SOFTWARE\KasperskyLab\protected\KES10SP2\Installer'
            fRegSet($computer)
            }
        elseif ($CompArch -eq "64-bit") 
            { 
            Write-Host $computer "64-bit"
            $global:regPath = 'HKLM:\SOFTWARE\Wow6432Node\KasperskyLab\protected\KES10SP2\Installer'
            fRegSet($computer)
            }
        else { Write-Host $computer "something wrong!!!" -foregroundcolor Red }
    
    } 

    else
        {#"---------------------------------------------------"
            Write-Host $computer "Offline" -foregroundcolor Gray 
        }

}