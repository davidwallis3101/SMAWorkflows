﻿#Create Portable module remotely
#Install powercli 5.8 first for this example

# Configure Endpoint here
$WebServiceEndpoint = 'https://sma'

# Create VMWare vSphere portable module and store on current users desktop
New-SmaPortableModule -ModuleName "VMware.VimAutomation.Core" -OutputPath $([Environment]::GetFolderPath("Desktop")) -IsSnapIn

#Import the module into SMA
$File = [Environment]::GetFolderPath("Desktop") + "\VMware.VimAutomation.Core-Portable.zip"
Import-SmaModule -WebServiceEndpoint $WebServiceEndpoint -Path $File
