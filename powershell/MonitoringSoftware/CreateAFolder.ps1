Configuration CreateAFolder
 {
 Node $AllNodes.NodeName {
 File MyNewFolder
 {
             Ensure = 'Present'
             DestinationPath = $Node.FolderPath
             Type = 'Directory'
 }
     }
 }