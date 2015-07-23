workflow UseMultipleConnections
{
    # Get all connections of a given type
    $enviroments = Get-AutomationConnections -ConnectionType "VMware.VimAutomation.Core"

    # Step through each connection and do something.
    foreach ($env in $enviroments)
    {
        Write-Verbose "Connecting to $env.Name $env.Description"

        $con = Get-AutomationConnection -Name $env.Name
        write-output "Env: $($env.Name) UserName: $($con.UserName) ComputerName: $($con.ComputerName)"
    }
}