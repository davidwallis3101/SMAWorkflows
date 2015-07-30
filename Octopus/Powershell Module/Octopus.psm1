function Get-OctopusUsers {
	[CmdletBinding()]
	[OutputType([System.Int32])]
	param(
		[Parameter(Position=0, Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[Uri]$OctopusURI,
		
		[Parameter(Position=1, Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[System.String]$apiKey
	)
	
	try {
		#Creating a connection
		$endpoint = new-object Octopus.Client.OctopusServerEndpoint $OctopusURI, $apiKey
		$repository = new-object Octopus.Client.OctopusRepository $endpoint

		$repository.Users.FindAll()
	}
	catch {
		throw
	}
}

function Get-OctopusMachine {
	[CmdletBinding()]
	[OutputType([System.Int32])]
	param(
		
		[Parameter(Position=0, Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[System.String]$Name,
		
		[Parameter(Position=1, Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[Uri]$OctopusURI,
		
		[Parameter(Position=2, Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[System.String]$apiKey

	)
	
	try {
		#Creating a connection
		$endpoint = new-object Octopus.Client.OctopusServerEndpoint $OctopusURI, $apiKey
		$repository = new-object Octopus.Client.OctopusRepository $endpoint
		
		[Octopus.Client.Model.MachineResource]$Machine = $null
		
		try{
			$machine = $repository.Machines.FindByName($Name)
			Write-Debug "Machine found by name`n " +($Machine|Ft)
			return $Machine
		}catch{
			Write-Debug "Machine not found by name"
		}

		$Machines = $repository.Machines.FindAll()
		Foreach ($Machine in $Machines) {
			$matched = $Machine.Uri -match '(?:https://|http://)([\w\.]+)(?::\d+)'
			if ($Matches[1] -eq $Name) {
				Write-Debug "Found machine using uri"
				return $machine
			}
		};
	}
	catch {
		throw
	}
	return $null
}

function Remove-OctopusMachine {
	[CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="High")]
	[OutputType([System.Int32])]
	param(
		
		[Parameter(Position=0, Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		$Machine,
		
		[Parameter(Position=1, Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[Uri]$OctopusURI,
		
		[Parameter(Position=2, Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[System.String]$apiKey

	)
	
	try {
	
		#Creating a connection
		$endpoint = new-object Octopus.Client.OctopusServerEndpoint $OctopusURI, $apiKey
		$repository = new-object Octopus.Client.OctopusRepository $endpoint

		# Only run if confirmed to delete 
		if ($pscmdlet.ShouldProcess("Remove Machine`n $($Machine.uri)")) {
			write-verbose "Deleting Machine: `n $($Machine)"
			$response = $repository.Machines.Delete($Machine)
			Write-Verbose "Job state: " $response.State
		}
	}
	catch {
		throw
	}
}

Function Reset-OctopusMachine {
	[CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="High")]
	[OutputType([System.Int32])]
	param(
		
		[Parameter(Position=0, Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		$Machine,
		
		[Parameter(Position=1, Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[Uri]$OctopusURI,
		
		[Parameter(Position=2, Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[System.String]$apiKey

	)
	
	try {
	
		#Creating a connection
		$endpoint = new-object Octopus.Client.OctopusServerEndpoint $OctopusURI, $apiKey
		$repository = new-object Octopus.Client.OctopusRepository $endpoint
		
		# Only run if confirmed to delete 
		if ($pscmdlet.ShouldProcess("Remove Machine`n $($Machine.uri)")) {
			Write-Verbose "Setting Squid to Null value on £($Machine.Name)"
			$Machine.Squid = ""
			$repository.Machines.Modify($Machine);
		}
	}
	catch {
		throw
	}
}
