<#
.SYNOPSIS
    Convert Windows 10/11 Enterprise to Professional
   
.DESCRIPTION
    The script will get the Embeded OEM activation key and activate the installed professional operating system.

.NOTES
    Version: 1.0
    Original Author: Shishir Kushawaha
    Modifiedby: Shishir Kushawaha
    Email: srktcet@gmail.com    
    Date Created: 25-03-2023
#>

#region Variable declaration
$logfile = "c:\temp\convertEntToPro.log"
$ActivationKey=$null #replace $null with your own key
if($null -eq $ActivationKey)
{
    $ActivationKey=(Get-CimInstance -query 'select * from SoftwareLicensingService').OA3xOriginalProductKey
}

#endregion Variable declaration

Write-Output "" | Out-File $logfile -append
Write-Output "SECTION START : Professional Activation. : $(Get-Date)" | Out-File $logfile -append
write-output "Firmware-embedded product key is '$ActivationKey'" | Out-File $logfile -append

#region Install and activate OEM key
if($null -ne $ActivationKey)
{
    try 
    {
        cscript.exe "$env:SystemRoot\System32\slmgr.vbs" /ipk $ActivationKey | Out-File $logfile -append
        write-Output "Installed license key successfully." | Out-File $logfile -append
        cscript.exe "$env:SystemRoot\System32\slmgr.vbs" /ato | Out-File $logfile -append
        write-Output "Windows activated with OEM Activation Key $ActivationKey" | Out-File $logfile -append 
    }
    catch [exception]
    {
        Write-output "Failed activate." | Out-File $logfile -append
        Write-output $_ | Out-File $logfile -append
    }
}
else 
{
    Write-output "Firmware-embedded product key does not exists." | Out-File $logfile -append
}
#endregion Install and activate OEM key

#region Check Product Key Channel
$ProductKeyChannel=(Get-WmiObject SoftwareLicensingProduct -Filter "ApplicationID = '55c92734-d682-4d71-983e-d6ec3f16059f' and LicenseStatus = '1'").ProductKeyChannel
if($ProductKeyChannel -eq "OEM:DM") 
{
    write-Output "Windows activated, ProductKeyChannel = '$ProductKeyChannel'" | Out-File $logfile -append
}
#endregion Check Product Key Channel    
Write-Output "SECTION END : Professional Activation. : $(Get-Date)" | Out-File $logfile -append