param($Timer)

. $PSScriptRoot\SongkickToSpotify.ps1

Write-Host "Running Songkick to Spotify. $($Timer)"

Update-PlaylistsFromJson

Write-Host "Done!"