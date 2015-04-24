workflow Hello-World
{
	$out = InlineScript
	{
		Write-Output "Hello World"
	}
	Write-output $out
}