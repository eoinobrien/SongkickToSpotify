. $PSScriptRoot\Common.ps1
. $PSScriptRoot\Spotify.ps1
. $PSScriptRoot\Songkick.ps1
. $PSScriptRoot\SpotifyAuth.ps1


$SongkickAPIKey = ""
$SpotifyKey = "Bearer $(Refresh-AuthToken)"

$cities = @("Milan");

$playlists = @()


foreach ($city in $cities)
{
	$locations = Search-Locations $city

	$playlist = @{
		"PlaylistId" = "a"
		"PlaylistTitle" = "Upcoming $city"
		"Area" = $city
		"MetroId" = $locations[0].metroArea.id
		"PhotoCredit" = "a"
		"Offset" = 14
	}

	$spotifyPlaylist = New-Playlist $playlist.PlaylistTitle

	$playlist.PlaylistId = $spotifyPlaylist.id

	$playlists += $playlist
}

return $playlists