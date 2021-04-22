Set-StrictMode -version latest;

. .\Common.ps1
. .\Songkick.ps1
. .\Spotify.ps1

$SongkickAPIKey = "wk8Wn7sa4eq8L7WC"
$SpotifyKey = "Bearer BQD4py2m7pbC-Z4NQi1-Xezjo21vMLwECEX84vU707nCZykNeHTqfURfYw3RhVYwwc_u0mrM3O6Y7V_GFQWweGUzaIEfCxldso2H5mHM0J2TpyT2QGKPQC6tz70_YelH4zdg-tT-dWr3pdX3kMWDnUFy2xtGXgsoEwfn6zQzYI5wnMhXmwkxUK0nluaWhq0VBC5uUXQbDnEmwQdUhzyXlMO7hNlBidvw0_WegxIZik5OQfjiOb3qkOwUdP4du82D6_Ty6TQ8v3oyVsOra2QepS9B"

function Load-PlaylistCountries() {
	$playlists = Get-Content '.\Playlists.json' | Out-String | ConvertFrom-Json

	foreach ($playlist in $playlists) {
		Update-MetroPlaylist $playlist
	}
}

function Create-PlaylistDescription($Area, $Offset, $PhotoCredit)
{
	$dayWeekString = ($Offset % 7) -eq 0 ? "{0} weeks" -f ($Offset / 7) : "{0} days" -f $Offset

	return "Top tracks of artists who are performing in {0} in the next {1}. {2}" -f $Area, $dayWeekString, $PhotoCredit
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

	Delete-AllPlaylistTracks $playlistId

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

	$playlistDescription = Create-PlaylistDescription $Playlist.Area $Playlist.Offset $Playlist.PhotoCredit
	Change-PlaylistDetails $playlistId $Playlist.PlaylistTitle $playlistDescription $true
}

Load-PlaylistCountries