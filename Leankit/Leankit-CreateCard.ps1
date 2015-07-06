<# 
    Leankit-CreateCard - David Wallis 06/07/2015
    Uses the Leankit REST api to create a ticket from SMA

    Thanks to the information provided here http://sammart.in/2014/04/20/using-the-leankit-api-with-powershell/
#>
workflow Leankit-CreateCard
{
    param (
        # Phone Number
        [parameter(Mandatory=$true)]
        [string]$title,

        # Message contents
        [parameter(Mandatory=$true)]
        [string]$description,

        # Card Type
        [parameter(Mandatory=$false)]
        [string]$typeID = "22233222",

        # Lane ID
        [parameter(Mandatory=$false)]
        [string]$laneID = "11111111",

        # Priority
        [parameter(Mandatory=$false)]
        [string]$priority = "1",
        
        # Board ID
        [parameter(Mandatory=$false)]
        [string]$boardId = "12345678"
    )
    
    [string]$leanKitURL = "https://myaccountname.leankit.com"

    # Get credentials for connecting to the leankit api
    $Credentials = Get-AutomationPSCredential -Name 'LeankitCredential'

    # Create the card array
    $cardArray = @()
    $cardArray += @{
        Title = $title
        Description =  $description
        TypeID=$typeID
        laneID=$laneID
        Priority = $priority
    }

    # Construct the URI and submit the call via REST 
    [string]$Adduri = $leanKitURL + "/Kanban/Api/Board/$($boardId)/AddCards"
    $resp = Invoke-RestMethod -Uri $Adduri -Credential $Credentials -Method Post -Body $(ConvertTo-Json $cardArray) -ContentType "application/json" #-Proxy http://myproxy:8080

    Write-output "Cardnumber: $($resp.ReplyData.Id)"
}