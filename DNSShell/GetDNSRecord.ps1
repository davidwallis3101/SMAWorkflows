workflow GetDNSRecord {

	#Retrieve DNS Server and credentials from Assets
	$Creds = Get-AutomationPSCredential -Name 'dnsaccount'
	
	[string]$Server = Get-AutomationVariable –Name 'DNSServer'
	
	get-dnsRecord -server $Server -RecordType A -Zone "zonename" -credential $Creds | select Name #|where {$_.Name -like "StartOfName*"} 
	# Where command above causes issues.. need to determine what this is.
}