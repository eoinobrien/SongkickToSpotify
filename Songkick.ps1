function Get-UpcomingAustinConcerts()
{
	$SongkickApiKey = "REPLACE_ME"
	# Limit of 50 per page
	# $MetroId = "9179" # AUSTIN
	$MetroId = "29314" # Dublin
	$AustinSongkick = "https://api.songkick.com/api/3.0/metro_areas/$MetroId/calendar.json?apikey=$SongkickApiKey&min_date=2019-08-10&max_date=2019-08-31"

	$Concerts = Get-PagedUpcomingConcertResults $AustinSongkick

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