Set-StrictMode -version latest;

. .\Common.ps1
. .\Spotify.ps1

$artists = @(
    "Lisa O'Neill",
    "Soda Blonde",
    "Bicep",
    "Ailbhe Reddy",
    "Jape",
    "Nealo",
    "David Kitt",
    "U2",
    "Maria Somerville",
    "Van Morrison",
    "Hazey Haze",
    "Rachael Lavelle",
    "R.S.A.G.",
    "Woven Skull",
    "Lisa Hannigan",
    "Imelda May",
    "Columbia Mills",
    "Paddy Hanna",
    "Aislinn Logan",
    "Hozier",
    "Wyvern Lingo",
    "Pat Lagoon",
    "Cmat",
    "Anna Mieke",
    "The Murder Capital",
    "Rejjie Snow",
    "A Lazarus Soul",
    "Alex Gough",
    "Junior Brother",
    "Just Mustard",
    "Odd Morris",
    "Bleeding Heart Pigeons",
    "Ellll",
    "Roisin Murphy",
    "Kojaque",
    "Mango X MathMan",
    "Villagers",
    "Maija Sofia",
    "Brian Deady",
    "Sinead O'Brien",
    "Silverbacks",
    "God Knows",
    "Lankum",
    "The Divine Comedy",
    "Sorcha Richardson",
    "Aoife Nessa Frances",
    "Girl Band",
    "Pillow Queens",
    "Fontaines D.C.",
    "Denise Chaila");

$SpotifyKey = "Authorization: Bearer <replace>"

[array]::Reverse($artists)

foreach($artist in $artists) {
    Write-Host $artist

    $spotifyArtist = Get-SpotifyArtist $artist

    if ($null -ne $spotifyArtist)
    {
        $TopTracks = Get-ArtistTopTracks $spotifyArtist.id

        if ($TopTracks.tracks.Length -ne 0)
        {
            $TopTracksUris = Get-TopNTrackUris $TopTracks 3 $true
            if ($TopTracksUris)
            {
                Add-TracksToPlaylist "3TI2ApOvCkFhdgQamUSrE4" $TopTracksUris
            }
            else
            {
                Write-Host "No non explicit Top Tracks for '$($artist)' on Spotify, skipping."
            }
        }
        else
        {
            Write-Host "No Top Tracks for '$($artist)' on Spotify"
        }
    }
    else
    {
        Write-Host "Unable to find '$($artist)' on Spotify"
    }
}