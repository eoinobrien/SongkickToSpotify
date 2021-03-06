function Invoke-PostRestMethodAndHandleExceptions($Method, $Uri, $Body, $Headers = @{ "Content-Type" = "application/json"})
{
	try
	{
		$result = Invoke-WebRequest -Method $Method -Uri $Uri -Headers $headers -Body $Body
	}
	catch
	{
		if ($_.Exception.Response.StatusCode -eq 429)
		{

			if($null -eq $_.Exception.Response.Headers.RetryAfter)
			{
				$waitForSeconds = 10;
			}
			else
			{
				$waitForSeconds = $_.Exception.Response.Headers.RetryAfter.Delta.Seconds + 1;
			}

			Write-Host "Spotify Rate Limit hit. Pausing for $waitForSeconds seconds."

			Start-Sleep -s $waitForSeconds

			return Invoke-PostRestMethodAndHandleExceptions $Method $Uri $Body $headers
		}
		else
		{
			Write-Host "ERROR: $(Get-ErrorFromResponseBody $_ | Format-Table | Out-String)"
			Write-Host "Exiting"
			exit
		}
	}

	return $($result.Content | ConvertFrom-Json)
}

function Get-ErrorFromResponseBody($ResponseError)
{
	if ($PSVersionTable.PSVersion.Major -lt 6)
	{
		if ($ResponseError.Exception.Response)
		{
			$Reader = New-Object System.IO.StreamReader($Error.Exception.Response.GetResponseStream())
			$Reader.BaseStream.Position = 0
			$Reader.DiscardBufferedData()
			$ResponseBody = $Reader.ReadToEnd()

			if ($ResponseBody.StartsWith('{'))
			{
				$ResponseBody = $ResponseBody | ConvertFrom-Json

				$ResponseBody = "Status: $($ResponseBody.error.status); Message: $($ResponseBody.error.message)"
			}

			return $ResponseBody
		}
	}
	else
	{
		return $Error.ErrorDetails.Message
	}
}

Export-ModuleMember -Function Invoke-PostRestMethodAndHandleExceptions