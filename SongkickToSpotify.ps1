Set-StrictMode -version latest;

$SpotifyApiUri = "https://api.spotify.com/v1";

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

function Invoke-PostRestMethodAndHandleExceptions($Method, $Uri, $Body, $Headers = @{ "Content-Type" = "application/json"})
{
	try
	{
		$result = Invoke-WebRequest -Method $Method -Uri $Uri -Headers $headers -Body $Body
	}
	catch [System.Net.WebException]
	{
		if ($_.Exception.Response.StatusCode -eq 429)
		{
			Write-Host "Spotify Rate Limit hit. Pausing."

			if($null -eq $_.Exception.Response.Headers["Retry-After"])
			{
				$waitForSeconds = 10;
			}
			else
			{
				$waitForSeconds = $_.Exception.Response.Headers["Retry-After"]
			}

			Start-Sleep -s $waitForSeconds

			return Invoke-PostRestMethodAndHandleExceptions $Method $Uri $Body $headers
		}
		else
		{
			Write-Error "ERROR: " $(Get-ErrorFromResponseBody $_)
		}
	}
	catch
	{
		Write-Error "Error when invoking method. Unknown Error."
	}

	return $($result.Content | ConvertFrom-Json)
}


function Get-ErrorFromResponseBody($Error)
{
	if ($PSVersionTable.PSVersion.Major -lt 6)
	{
		if ($Error.Exception.Response)
		{
			$Reader = New-Object System.IO.StreamReader($Error.Exception.Response.GetResponseStream())
			$Reader.BaseStream.Position = 0
			$Reader.DiscardBufferedData()
			$ResponseBody = $Reader.ReadToEnd()

			if ($ResponseBody.StartsWith('{'))
			{
				$ResponseBody = $ResponseBody | ConvertFrom-Json
			}

			return $ResponseBody
		}
	}
	else
	{
		return $Error.ErrorDetails.Message
	}
}


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


function Invoke-SpotifyRequest($Method, $Uri, $Body)
{
	$headers = @{
		"Content-Type" = "application/json"
		"Accept" = "application/json"
		"Authorization" = $SpotifyKey
	}

	return Invoke-PostRestMethodAndHandleExceptions $Method $Uri $Body $headers
}

function Search-SpotifyForArtist($Artist)
{
	$searchQuery = '{0}/search?q="{1}"&type=artist&market=IE' -f $SpotifyApiUri, $Artist
	return Invoke-SpotifyRequest 'Get' $searchQuery
}

function Get-SpotifyArtist($Artist)
{
	$spotifyArtist = $null

	foreach($searchArtist in $(Search-SpotifyForArtist $Artist).artists.items ) {
		if ($searchArtist.name -eq $Artist)
		{
			$spotifyArtist = $searchArtist
			break;
		}
	}

	return $spotifyArtist
}

function Get-ArtistTopTracks($ArtistId)
{
	$searchQuery = '{0}/artists/{1}/top-tracks?country=IE' -f $SpotifyApiUri, $ArtistId
	return Invoke-SpotifyRequest 'Get' $searchQuery
}

function Get-TopNTrackUris($TopTracks, $N, $AllowExplict)
{
	$TopTracks = $TopTracks.tracks

	if (-not $AllowExplict)
	{
		$TopTracks = $TopTracks | where explicit -eq $false
	}

	if ($TopTracks.Length -lt $N)
	{
		return ($TopTracks | Select-Object -expand uri) -join ","
	}

	return ($TopTracks[0..$($N-1)] | Select-Object -expand uri) -join ","
}

function Add-TracksToPlaylist($TrackUris)
{
	# $PlaylistId = "4wPXJkwA3tcDv7ovgOoXcY" # AUSTIN
	$PlaylistId = "7pCFHK5QN7JpNnZeWHUVpw" #Dublin

	$url = "{0}/playlists/{1}/tracks?uris={2}" -f $SpotifyApiUri, $PlaylistId, $TrackUris

	return Invoke-SpotifyRequest 'Post' $url
}

$SpotifyKey = "Authorization: Bearer REPLACE_ME"
$upcomingConcerts = Get-UpcomingAustinConcerts
$previouslyAddedArtists = @();

foreach($concert in $upcomingConcerts) {
	foreach($performance in $concert.performance) {
		if($previouslyAddedArtists.Contains($performance.displayName))
		{
			continue;
		}

		Write-Host $performance.displayName

		$spotifyArtist = Get-SpotifyArtist $performance.displayName

		if ($null -ne $spotifyArtist)
		{
			$TopTracks = Get-ArtistTopTracks $spotifyArtist.id

			if ($TopTracks.tracks.Length -ne 0)
			{
				$TopTracksUris = Get-TopNTrackUris $TopTracks 3 $false
				Add-TracksToPlaylist $TopTracksUris
			}
			else
			{
				Write-Host "No Top Tracks for '$($performance.displayName)' on Spotify"
			}

			$previouslyAddedArtists += $performance.displayName
		}
		else
		{
			Write-Host "Unable to find '$($performance.displayName)' on Spotify"
		}
	}
}