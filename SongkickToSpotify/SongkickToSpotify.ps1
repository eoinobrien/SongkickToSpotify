Set-StrictMode -version latest;
Import-Module $PSScriptRoot\Modules\SpotifyAuth.psm1

$spotifyKey = "Bearer $(Refresh-AuthToken)"
$psRoot = $PSScriptRoot;

function Update-PlaylistsFromJson() {
	$playlists = Get-Content "$($PSScriptRoot)\Playlists.json" | Out-String | ConvertFrom-Json

	$playlists | ForEach-Object -Parallel {
		Import-Module $Using:psRoot\Modules\Songkick;
		Import-Module $Using:psRoot\Modules\Spotify;
		Import-Module $Using:psRoot\Modules\Common;

		$SpotifyKey = $Using:spotifyKey;

		function Set-PlaylistDescription($Area, $Offset, $PhotoCredit) {
			switch ($Offset) {
				{ $Offset -eq 7 } {
					$dayWeekString = "this week"
					continue
				}
				{ $Offset -eq 1 } {
					$dayWeekString = "tonight"
					continue
				}
				{ ($Offset % 7) -eq 0 } {
					$dayWeekString = "in the next {0} weeks" -f ($Offset / 7)
					continue
				}
				Default {
					$dayWeekString = "in the next {0} days" -f $Offset
				}
			}

			return "Top tracks of artists who are performing in {0} {1}. Concert data from Songkick. {2}" -f $Area, $dayWeekString, $PhotoCredit
		}

		function Get-PlaylistName($Type, $Area) {
			if ($Type -eq "Tonight") {
				return "Tonight in " + $Area
			}

			return $Type + " " + $Area
		}

		function Update-MetroPlaylist($Playlist) {
			$metroId = $Playlist.MetroId 
			$playlistId = $Playlist.PlaylistId
			$endOffset = $null -eq $Playlist.Offset ? 28 : $Playlist.Offset

			$startDate = (Get-Date).ToString("yyy-MM-dd")
			$endDate = (Get-Date).AddDays($endOffset).ToString("yyy-MM-dd")

			Write-Host "========================================="
			Write-Host "Getting Concerts for '$($Playlist.PlaylistTitle)'"
			Write-Host "========================================="
			$upcomingConcerts = Get-UpcomingConcerts $metroId $startDate $endDate

			Remove-AllPlaylistTracks $playlistId

			$previouslyAddedArtists = @();
			$tracksToAdd = @();

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
								$tracksToAdd += $TopTracksUris
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
			
			Add-TracksToPlaylist $playlistId $tracksToAdd

			$playlistDescription = Set-PlaylistDescription $Playlist.Area $Playlist.Offset $Playlist.PhotoCredit
			Set-PlaylistDetails $playlistId $(Get-PlaylistName $Playlist.PlaylistType $Playlist.Area) $playlistDescription $true
		}

		if ($null -ne $_.PlaylistId) {
			Update-MetroPlaylist $_
		}
	} -ThrottleLimit 3

	# foreach ($playlist in $playlists) {
	# }
}