function Get-SysInternals {
	
   param ( $sysIntDir="c:\sysint\" )
   
   if( !$sysIntDir.endsWith("\")) { $sysIntDir+="\" }
   $log = join-path $sysIntDir "changes.log"
   add-content -force $log -value "`n`n[$(get-date)]SysInternals sync has started"

      dir \\live.sysinternals.com\tools -recurse | foreach { 
	
         $fileName = $_.name
         $localFile = join-path $sysIntDir $_.name                  
         $exist = test-path $localFile
         
         $msgNew = "new utility found: $fileName , downloading..."
         $msgUpdate = "file : $fileName  is newer, updating..."
         $msgNoChange = "nothing changed for: $fileName"
         
	
         if($exist){

            if($_.lastWriteTime -gt (get-item $localFile).lastWriteTime){
               copy-item $_.fullname $sysIntDir -force
               write-host $msgUpdate -fore yellow
               add-content -force $log -value $msgUpdate
            } else {
               add-content $log -force -value $msgNoChange
               write-host $msgNoChange
            }

          } else {

               if($_.extension -eq ".exe") {
                  write-host $msgNew -fore green
                  add-content -force $log -value $msgNew
               } 

               copy-item $_.fullname $sysIntDir -force 
         }
   }
}