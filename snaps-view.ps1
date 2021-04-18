## Connect to vCenter
Connect-VIServer -Server localhost
$input=1..3

do{
   cls
   Write-Host "================================================" 
   Write-Host "  Welcome to vCenter multiChoice. version 0.23"
   Write-Host "================================================"
   $choice = Read-Host -Prompt "
    Please provide number for required action 
   ------------------------------------------
     1.Check for snapshot
     2.Check Size of VMs  
     3.Exit 
   ------------
   Choice" 
   } until ($Choice -in $input)

 If ($Choice -eq "1") {
   Get-VM | Sort Name | Get-Snapshot | Where { $_.Name.Length -gt 0 } | Select VM,Name,Description,@{N="SizeGB";E={[math]::Round(($_.SizeMB/1024),2)}}| Format-Table -AutoSize | out-file c:\ibm_apar\snaps_file.csv
   Write-Host "Snapshot file is stored in snaps_file.txt"
   Pause
   Invoke-Item c:\ibm_apar\snaps_file.csv
 }

 If ($Choice -eq "2") {
   $vmList = Get-Content C:\ibm_apar\servers.txt
   Get-VM $vmList | Select-Object Name,@{n="HardDiskSizeGB"; e={(Get-HardDisk -VM $_ | Measure-Object -Sum CapacityGB).Sum}} | Format-Table -AutoSize | out-file c:\ibm_apar\storage.csv
   Write-Host "Snapshot file is stored in storage.txt"
   Pause
   Invoke-Item c:\ibm_apar\storage.csv
 }

ElseIf ($Choice -eq "3"){
      Write-Host "
      Exiting Menu."
      Disconnect-VIServer localhost -Confirm:$false 
}
