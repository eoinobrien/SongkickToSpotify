
Import-Module $PSScriptRoot\SpotifyAuth.psm1

$SpotifyKey = "Bearer $(Refresh-AuthToken)"
$SpotifyApiUri = "https://api.spotify.com/v1";

function Invoke-SpotifyRequest($Method, $Uri, $Body) {
	$headers = @{
		"Content-Type"  = "application/json"
		"Accept"        = "application/json"
		"Authorization" = $SpotifyKey
	}

	return Invoke-PostRestMethodAndHandleExceptions $Method $Uri $Body $headers
}

function Get-PagedResultsItems($Method, $Url, $Body) {
	$items = @()
	$RequestUrl = $Url

	do {
		$results = Invoke-SpotifyRequest $Method $RequestUrl $Body
		$items += $results.items

		$RequestUrl = $results.next
	} while ($null -ne $RequestUrl)

	return $items
}

function Search-SpotifyForArtist($Artist) {
	$searchQuery = '{0}/search?q="{1}"&type=artist' -f $SpotifyApiUri, $Artist
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
		$TopTracks = $TopTracks | Where-Object explicit -eq $false
	}

	if ($null -eq $TopTracks) {
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

function Set-PlaylistDetails($PlaylistId, $Name, $Description, $Public = $false) {
	$url = "{0}/playlists/{1}" -f $SpotifyApiUri, $PlaylistId

	$body = @{
		"name"        = $Name
		"description" = $Description
		"public"      = $Public
	}

	return Invoke-SpotifyRequest 'Put' $url (ConvertTo-Json -InputObject $body)
}

function Get-AllPlaylistTracks($PlaylistId) {
	$url = "{0}/playlists/{1}/tracks" -f $SpotifyApiUri, $PlaylistId

	return Get-PagedResultsItems 'Get' $url
}

function Convert-ToDeletableTrackArray($Items) {
	$deletableTracks = @()

	foreach ($item in $Items) {
		$deletableTracks += @{"uri" = $item.track.uri }
	}

	return ,$deletableTracks
}

function Remove-TracksFromPlaylist($PlaylistId, $Tracks) {
	$url = "{0}/playlists/{1}/tracks" -f $SpotifyApiUri, $PlaylistId

	$body = @{
		"tracks" = $Tracks
	}

	return Invoke-SpotifyRequest 'Delete' $url (ConvertTo-Json -InputObject $body)
}

function Remove-AllPlaylistTracks($PlaylistId) {
	$playlistItems = Convert-ToDeletableTrackArray (Get-AllPlaylistTracks $PlaylistId)

	for ($i = 0; $i -lt $playlistItems.Count; $i += 99) {
		$limit = ($i + 99) -ge $playlistItems.Count ? $playlistItems.Count - 1 : $i + 99
		$deletableTrackArray = ($playlistItems[$i..$limit])
		Remove-TracksFromPlaylist $PlaylistId $deletableTrackArray
	}
}

function New-Playlist($Name) {
	$url = "{0}/users/{1}/playlists" -f $SpotifyApiUri, "1155679421"

	$body = @{
		"name" = $Name
	}

	return Invoke-SpotifyRequest 'Post' $url (ConvertTo-Json -InputObject $body)
}

Export-ModuleMember -Function Get-SpotifyArtist
Export-ModuleMember -Function Get-ArtistTopTracks
Export-ModuleMember -Function Get-TopNTrackUris
Export-ModuleMember -Function Add-TracksToPlaylist
Export-ModuleMember -Function Set-PlaylistDetails
Export-ModuleMember -Function Remove-AllPlaylistTracks
Export-ModuleMember -Function New-Playlist