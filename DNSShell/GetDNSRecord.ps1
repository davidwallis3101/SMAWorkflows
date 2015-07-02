workflow GetDNSRecord {

	#Retrieve DNS Server and credentials from Assets
	$Creds = Get-AutomationPSCredential -Name 'dnsaccount'
	
	#$Server = Get-AutomationVariable –Name 'DNSServer'
	$Server = "myserver.local"
	
	$records = InlineScript {
		Import-Module dnsShell
		get-dnsRecord -server $using:Server -RecordType A -Zone "zonename" -credential $using:Creds | select Name |where {$_.Name -like "StartOfName*"} 
	}
	
	Write-Output $records
}