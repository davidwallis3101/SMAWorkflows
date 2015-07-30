workflow SMA-GetOctopusUsers
{
    # Get connection object containing URI and API Key   		
    $conn = Get-AutomationConnection -Name 'TestServer'
   
    Get-OctopusUsers `
        -apiKey $conn.ApiKey `
        -OctopusURI $conn.URI 
)