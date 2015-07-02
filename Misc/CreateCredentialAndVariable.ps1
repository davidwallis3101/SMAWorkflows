######################################
# Create Credential and store in sma.
# David Wallis 02/07/2015
######################################

# Details of your webservice endpoint
$WebServiceEndpoint = 'https://sma'

# Store Credential in SMA using the username as the name of the credential
$cred = get-credential -Message "Enter the user name and password of the account you wish to store in SMA"
$newCredential = Set-SmaCredential -WebServiceEndpoint $WebServiceEndpoint -Name $cred.UserName -Value $Cred

# Display Credential Details
$newCredential.CredentialId
$newCredential.Name

# Create Variable
Set-AutomationVariable –Name 'VMWareServerName' –Value 'MyServerName.Blah.local'

# Get Variable
$server = Get-AutomationVariable –Name 'VMWareServerName'