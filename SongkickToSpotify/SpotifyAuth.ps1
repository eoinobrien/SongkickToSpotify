function Refresh-AuthToken() {
	$headers = @{
		Authorization = "Basic $($env:SPOTIFY_CLIENT_ID_SECRET)"
	}

	$body = @{
		grant_type    = 'refresh_token'
		refresh_token = $env:SPOTIFY_REFRESH_TOKEN
	}

	$contentType = 'application/x-www-form-urlencoded'

	$result = Invoke-WebRequest -Method "POST" -Uri "https://accounts.spotify.com/api/token" -Headers $headers -Body $body -ContentType $contentType

	return $($result.Content | ConvertFrom-Json).access_token
}