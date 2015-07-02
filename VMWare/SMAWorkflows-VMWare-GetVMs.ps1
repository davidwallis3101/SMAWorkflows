workflow SMAWorkflows-VMWare-GetVMs {
	#Retrieve credentials and viserver name from Assets
	$viServer = Get-AutomationVariable -Name 'VMwareServer'
	$Creds = Get-AutomationPSCredential -Name 'VMwareCredentials'
		 
	$Out = InlineScript {
		# Add VMWare Snapin (This needs creating as portable module - I used Powercli 5.8)
		# See other script for details
		Add-PSSnapin VMware.VimAutomation.Core | write-verbose

		# Ignore certificate errors
		Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -WarningAction SilentlyContinue -Scope Session -confirm:$false |out-null
		
		#Connect to the server if not connected. 
		if ($DefaultVIServers.Count -lt 1) {
		    Connect-VIServer -Server $using:viServer -Credential $using:Creds -Password $using:Password |write-verbose
		}
		
		# Crudely Get VM's where the name begins TestServer
		Get-VM -name TestServer*
	}
	Write-Output $out
}
