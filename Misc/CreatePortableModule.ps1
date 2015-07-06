#Create Portable module remotely

# Configure Endpoint here
$WebServiceEndpoint = 'https://sma'

$cred = get-credential
#$session = New-PSSession -computer "RemoteServerName" -cred $cred

# Create VMWare vSphere portable module and store on current users desktop
New-SmaPortableModule -Session $session -ModuleName "VMware.VimAutomation.Core" -OutputPath $([Environment]::GetFolderPath("Desktop")) -IsSnapIn

#Import the module inoto SMA
$File = [Environment]::GetFolderPath("Desktop") + "\VMware.VimAutomation.Core-Portable.zip"
Import-SmaModule -WebServiceEndpoint $WebServiceEndpoint -Path $File

#Create Credential
$WebServiceEndpoint = 'https://sma'
$cred = get-credential "Domain\VMWARE"
$newCredential = Set-SmaCredential -WebServiceEndpoint $WebServiceEndpoint -Name "VMWARE" -Value $Cred

$newCredential.CredentialId
$newCredential.Name