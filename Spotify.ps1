
$SpotifyApiUri = "https://api.spotify.com/v1";

function Invoke-SpotifyRequest($Method, $Uri, $Body) {
	$headers = @{
		"Content-Type"  = "application/json"
		"Accept"        = "application/json"
		"Authorization" = $SpotifyKey
	}

	return Invoke-PostRestMethodAndHandleExceptions $Method $Uri $Body $headers
}

function Search-SpotifyForArtist($Artist) {
	$searchQuery = '{0}/search?q="{1}"&type=artist&market=IE' -f $SpotifyApiUri, $Artist
	return Invoke-SpotifyRequest 'Get' $searchQuery
}

function Get-SpotifyArtist($Artist) {
	$spotifyArtist = $null
	$artistSearch = Search-SpotifyForArtist $Artist

	if ($artistSearch.artists.items.Count -eq 1) {
		$spotifyArtist = $artistSearch.artists.items[0];
		return $spotifyArtist;
	}

	foreach ($searchArtist in $($artistSearch.artists.items)) {
		if ($searchArtist.name -eq $Artist) {
			$spotifyArtist = $searchArtist
			break;
		}
	}

	return $spotifyArtist
}

function Get-ArtistTopTracks($ArtistId) {
	$searchQuery = '{0}/artists/{1}/top-tracks?country=IE' -f $SpotifyApiUri, $ArtistId
	return Invoke-SpotifyRequest 'Get' $searchQuery
}

function Get-TopNTrackUris($TopTracks, $N, $AllowExplict) {
	$TopTracks = $TopTracks.tracks

	if (-not $AllowExplict) {
		$TopTracks = $TopTracks | where explicit -eq $false
	}

    if ($null -eq $TopTracks)
    {
        return;
    }

	if (-not($TopTracks -is [array]) -or $TopTracks.Length -lt $N) {
		return ($TopTracks | Select-Object -expand uri) -join ","
	}

	return ($TopTracks[0..$($N - 1)] | Select-Object -expand uri) -join ","
}

function Add-TracksToPlaylist($PlaylistId, $TrackUris) {
	$url = "{0}/playlists/{1}/tracks?uris={2}" -f $SpotifyApiUri, $PlaylistId, $TrackUris

	return Invoke-SpotifyRequest 'Post' $url
}