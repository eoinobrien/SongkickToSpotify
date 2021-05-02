. $PSScriptRoot\SongkickToSpotify.ps1

# Input bindings are passed in via param block.
param($Timer)

# Write an information log with the current time.
Write-Host "Running Songkick to Spotify"

Update-PlaylistsFromJson

Write-Host "Done!"