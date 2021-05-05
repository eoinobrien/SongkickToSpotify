Set-StrictMode -version latest;

. $PSScriptRoot\Common.ps1
. $PSScriptRoot\Songkick.ps1
. $PSScriptRoot\Spotify.ps1
. $PSScriptRoot\SpotifyAuth.ps1

$SongkickAPIKey = $env:SONGKICK_API_KEY
$SpotifyKey = "Bearer $(Refresh-AuthToken)"
function Update-PlaylistsFromJson() {
	$playlists = Get-Content '.\SongkickToSpotify\Playlists.json' | Out-String | ConvertFrom-Json

	foreach ($playlist in $playlists) {
		if ($null -ne $playlist.PlaylistId) {
			Update-MetroPlaylist $playlist
		}
	}
}

function Set-PlaylistDescription($Area, $Offset, $PhotoCredit) {
	switch ($Offset) {
		{ $Offset -eq 7 } {
			$dayWeekString = "week"
			continue
		}
		{ $Offset -eq 1 } {
			$dayWeekString = "day"
			continue
		}
		{ ($Offset % 7) -eq 0 } {
			$dayWeekString = "{0} weeks" -f ($Offset / 7)
			continue
		}
		Default {
			$dayWeekString = "{0} days" -f $Offset
		}
	}

	return "Top tracks of artists who are performing in {0} in the next {1}. Concert data from Songkick. {2}" -f $Area, $dayWeekString, $PhotoCredit
}

function Update-MetroPlaylist($Playlist) {
	$metroId = $Playlist.MetroId 
	$playlistId = $Playlist.PlaylistId
	$endOffset = $null -eq $Playlist.Offset ? 28 : $Playlist.Offset

	$startDate = (Get-Date).ToString("yyy-MM-dd")
	$endDate = (Get-Date).AddDays($endOffset).ToString("yyy-MM-dd")	


	Write-Host "========================================="
	Write-Host "Getting Concerts from '$($Playlist.Area)'"
	Write-Host "========================================="
	$upcomingConcerts = Get-UpcomingConcerts $metroId $startDate $endDate

	Remove-AllPlaylistTracks $playlistId

	$previouslyAddedArtists = @();

	foreach ($concert in $upcomingConcerts) {
		foreach ($performance in $concert.performance) {
			if ($previouslyAddedArtists.Contains($performance.displayName)) {
				continue;
			}

			$spotifyArtist = Get-SpotifyArtist $performance.displayName

			if ($null -ne $spotifyArtist) {
				$TopTracks = Get-ArtistTopTracks $spotifyArtist.id

				if ($TopTracks.tracks.Length -ne 0) {
					$TopTracksUris = Get-TopNTrackUris $TopTracks 3 $false

					if ($null -ne $TopTracksUris) {
						Add-TracksToPlaylist $playlistId $TopTracksUris
					}
					else {
						Write-Host "There are Top Tracks for '$($performance.displayName)' but none that we can add (probably thanks to explict filter)"
					}
				}
				else {
					Write-Host "No Top Tracks for '$($performance.displayName)' on Spotify"
				}

				$previouslyAddedArtists += $performance.displayName
			}
			else {
				Write-Host "Unable to find '$($performance.displayName)' on Spotify"
			}
		}
	}

	$playlistDescription = Set-PlaylistDescription $Playlist.Area $Playlist.Offset $Playlist.PhotoCredit
	Set-PlaylistDetails $playlistId $Playlist.PlaylistTitle $playlistDescription $true
}