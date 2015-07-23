workflow Get-AutomationConnections
{
    param (
        # Connection Type (Check DB if unsure of the name)
        [parameter(Mandatory=$true)]
        [string]$ConnectionType
    )
    
    [string] $Server="YourSMADBServer"
    [string] $Database="SMA"
    
    $Out = inlinescript { 
        
        # Construct SQL Query
        [string] $SQLQuery="SELECT Core.ConnectionTypes.Name AS ConnectionType, Core.Connections.Description, Core.Connections.Name AS Name, Core.Connections.ConnectionId"
        $SQLQuery+= " FROM Core.Connections"
        $SQLQuery+= " INNER JOIN Core.ConnectionTypes ON Core.Connections.ConnectionTypeKey = Core.ConnectionTypes.ConnectionTypeKey"
        $SQLQuery+= " WHERE Core.Connections.IsDeleted = 'FALSE'"
        $SQLQuery+= " AND Core.ConnectionTypes.Name = '$Using:ConnectionType'"

        Try
        { 
            $SqlConnection = New-Object System.Data.SqlClient.SqlConnection
            $connectionString = "Server=$Using:Server;Database=$Using:Database;Integrated Security=True;Initial Catalog=SMA"
            $SqlConnection.ConnectionString = $connectionString
    
            $SqlCmd = New-Object System.Data.SqlClient.SqlCommand 
            $SqlCmd.CommandText = $SqlQuery 
            $SqlCmd.Connection = $SqlConnection
             
            $SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter 
            $SqlAdapter.SelectCommand = $SqlCmd
    
            $DataSet = New-Object System.Data.DataSet
            $RowCount = $SqlAdapter.Fill($DataSet) 
            $SqlConnection.Close()
             
            foreach ($row in $DataSet.Tables[0].Rows)     
            { 
                # Return the results from the query for processing in calling workflow.
                write-output $row
            }
        } 
        Catch 
        { 
            Write-Error $_ 
        } 
    }
    write-output $out
}