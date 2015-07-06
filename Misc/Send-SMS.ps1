<# 
This workflow sends an SMS message via the AQL SMS gateway
See here for API Details http://www.aql.com/sms/integrated/sms-api/
David Wallis 04/07/2015 smaworkflows.codeplex.com
#>
workflow Send-SMS
{
    param (
        # Phone Number
        [parameter(Mandatory=$true)]
        [string]$number,

        # Message contents
        [parameter(Mandatory=$true)]
        [string]$message,

        # Originator
        [parameter(Mandatory=$false)]
        [string]$originator
    )

    $url = "https://gw1.aql.com/sms/postmsg.php"

    #Get credentials for connecting to the aql api  
    $Credentials = Get-AutomationPSCredential -Name 'AQLCredentials'
    
    # Get the username and password
    $Password = $Credentials.GetNetworkCredential().Password
    $Username = $Credentials.Username
        
    # Construct the URL and submit the request
    $uri = "$($url)?to_num=$($number)&message=$($message)&flash=0&orig=$($originator)&username=$($Username)&password=$($Password)"
    $response = Invoke-WebRequest -Uri $uri -Method Post -ContentType "application/x-www-form-urlencoded" -UseBasicParsing #-Proxy http://myproxyserver:8080 

    # Check the response content
    switch -CaseSensitive ($response.Content) {
        "AQSMS-OK" {
            Write-Output "Message sent successfully to $($number)"
        }
        "AQSMS-AUTHERROR" {
            Write-Error "Authentication Error."
        }
        default {
            Write-Output "Unknown Response: $($response.Content)"
        }
    }
}