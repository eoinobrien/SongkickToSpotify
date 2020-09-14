Set-StrictMode -version latest;

. .\Common.ps1
. .\Songkick.ps1
. .\Spotify.ps1

$SpotifyKey = "Authorization: Bearer <replace>"
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
				Add-TracksToPlaylist "7pCFHK5QN7JpNnZeWHUVpw" $TopTracksUris
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