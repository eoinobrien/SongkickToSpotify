function Get-UpcomingConcerts($MetroId, $StartDate, $EndDate)
{
	$SongkickAPIKey = $env:SONGKICK_API_KEY

	$MetroCalendar = "https://api.songkick.com/api/3.0/metro_areas/$MetroId/calendar.json?apikey=$SongkickAPIKey&min_date=$StartDate&max_date=$EndDate"

	$Concerts = Get-PagedUpcomingConcertResults $MetroCalendar

	return $Concerts
}

function Get-PagedUpcomingConcertResults($Uri)
{
	$concerts = @()
	$continue = $true
	$page = 1

	while ($continue)
	{
		$RequestUri = $Uri + "&page=$page"
		$concertsPage = Invoke-PostRestMethodAndHandleExceptions 'Get' $RequestUri
		$concerts += $concertsPage.resultsPage.results.event
		$continue = $concertsPage.resultsPage.totalEntries -gt ($concertsPage.resultsPage.perPage * $concertsPage.resultsPage.page)

		$page = $page + 1
	}

	return $concerts
}

function Search-Locations($Query)
{
	$RequestUri = "https://api.songkick.com/api/3.0/search/locations.json?apikey=$SongkickAPIKey&query=$Query"

	$locations = Invoke-PostRestMethodAndHandleExceptions 'Get' $RequestUri

	return $locations.resultsPage.results.location
}

Export-ModuleMember -Function Get-UpcomingConcerts
Export-ModuleMember -Function Search-Locations