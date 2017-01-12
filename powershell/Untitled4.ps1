$ComputerName = Read-Host -Prompt 'Remote computer Hostname or IP'  
  $MOFfiles = "c:\temp\$computername"   
    
  #Create connection to remote computer   
  $RemoteAdministratorCred = Get-Credential -UserName Administrator -Message "$ComputerName Administrator password"   
  $CimSession = New-CimSession -ComputerName $ComputerName -Credential $RemoteAdministratorCred -Name $ComputerName   
   
  Configuration CopyDSCModuleRemotely {   
   Node $ComputerName {   
     File CreateFolder {  
       Ensure = 'Present'  
       Type = 'Directory'  
       DestinationPath = 'C:\Temp'  
     }  
   
     Script Download-xActiveDirectory {  
       GetScript = {  
         @{Result = Test-Path 'C:\Temp\xActiveDirectory.zip'}  
       }  
       SetScript = {  
         $xActiveDirectoryUrl = 'http://us-dsc.groupe.remy.cointreau/modules/xActiveDirectory.zip'  
         Invoke-WebRequest -Uri $xActiveDirectoryUrl -OutFile 'C:\Temp\xActiveDirectory.zip'  
         Unblock-File -Path 'C:\Temp\xActiveDirectory.zip'  
           
       }  
       TestScript = {  
         Test-Path 'C:\Temp\xActiveDirectory.zip'  
       }  
       DependsOn = '[File]CreateFolder'  
     }  
   
     Archive Uncompress-xActiveDirectory {  
       Ensure = 'Present'  
       Path = 'C:\Temp\xActiveDirectory.zip'  
       Destination = 'C:\Program Files\WindowsPowerShell\Modules\xActiveDirectory'  
       DependsOn = '[Script]Download-xActiveDirectory'  
     }  
   }  
 }  
   
  #Generate mof files   
  CopyDSCModuleRemotely -OutputPath $MOFfiles #-ConfigurationData $ConfigurationData   
    
  #Start Deployment remotely   
  Start-DscConfiguration -Path $MOFfiles -Verbose -CimSession $CimSession -Wait -Force   
   
  #Get deployied settings  
  #Get-DscConfiguration -CimSession $CimSession  