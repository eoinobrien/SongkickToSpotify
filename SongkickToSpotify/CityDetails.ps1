Import-Module $PSScriptRoot\Modules\Common.psm1
Import-Module $PSScriptRoot\Modules\Spotify.psm1
Import-Module $PSScriptRoot\Modules\Songkick.psm1
Import-Module $PSScriptRoot\Modules\SpotifyAuth.psm1


function Add-CommaToString($string)
{
	return $string ? "$string, " : '';
}

$SongkickAPIKey = ""
$SpotifyKey = "Bearer $(Refresh-AuthToken)"

$cities = @(
	@{
		City    = "Milan"
		Region    = ""
		Country = "Italy"
	}
);

$playlists = @()


foreach ($city in $cities) {
	$cityName = ("$(Add-CommaToString $city.City)$(Add-CommaToString $city.Region)$(Add-CommaToString $city.Country)").TrimEnd(", ")

	$locations = Search-Locations $cityName

	$playlist = @{
		"PlaylistId"    = "a"
		"PlaylistTitle" = "Upcoming $city.City"
		"Area"          = $city
		"MetroId"       = $locations[0].metroArea.id
		"PhotoCredit"   = "a"
		"Offset"        = 14
	}

	$spotifyPlaylist = New-Playlist $playlist.PlaylistTitle

	$playlist.PlaylistId = $spotifyPlaylist.id

	$playlists += $playlist
}

return $playlists