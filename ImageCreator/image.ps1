# Orignal code from http://www.ravichaganti.com/blog/?p=1012

. $PSScriptRoot\Resize-Image.ps1

enum PlaylistType {
    Tonight
    Upcoming
}
function AddTextToImage (
        [Parameter(Mandatory = $true)][String] $sourcePath,
        [Parameter(Mandatory = $true)][String] $destPath,
        [Parameter(Mandatory = $true)][String] $LineOne,
        [Parameter(Mandatory = $true)][String] $LineTwo)
{

    Write-Verbose "Load System.Drawing"
    [Reflection.Assembly]::LoadWithPartialName("System.Drawing") | Out-Null

    Write-Verbose "Get the image from $sourcePath"
    $srcImg = [System.Drawing.Image]::FromFile($sourcePath)

    Write-Verbose "Create a bitmap as $destPath"
    $bmpFile = New-Object System.Drawing.Bitmap([int]($srcImg.width)), ([int]($srcImg.height))

    Write-Verbose "Intialize Graphics"
    $Image = [System.Drawing.Graphics]::FromImage($bmpFile)
    $Image.SmoothingMode = "AntiAlias"

    $Rectangle = New-Object Drawing.Rectangle 0, 0, $srcImg.Width, $srcImg.Height
    $Image.DrawImage($srcImg, $Rectangle, 0, 0, $srcImg.Width, $srcImg.Height, ([Drawing.GraphicsUnit]::Pixel))

    $Font = New-Object System.Drawing.Font("Bebas Neue", 441)
    $Brush = New-Object Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 255, 255, 255))

    Write-Verbose "Draw title: $LineOne"
    $Image.DrawString($LineOne, $Font, $Brush, -20, 1812)

    Write-Verbose "Draw title: $LineTwo"
    $Image.DrawString($LineTwo, $Font, $Brush, -20, 2348)

    Write-Verbose "Save and close the files"
    $bmpFile.save($destPath, [System.Drawing.Imaging.ImageFormat]::Bmp)
    $bmpFile.Dispose()
    $srcImg.Dispose()
}

function New-DefaultCoverArt([PlaylistType] $playlistType, [string] $city)
{
    $imagePath = "$PSScriptRoot\..\site\src\components\Playlist\cover-art\$playlistType\FullSizeBackup\Blank.jpg";

    $cityImagePath = $city -replace '\s','' -replace ',',''
    $outputPath = "$PSScriptRoot\..\site\src\components\Playlist\cover-art\$playlistType\FullSizeBackup\$cityImagePath.jpg";

    if ($playlistType -eq [PlaylistType]::Tonight)
    {
        AddTextToImage $imagePath $outputPath $city $playlistType
    }
    else {
        AddTextToImage $imagePath $outputPath $playlistType $city 
    }

    Resize-CoverArtImage $outputPath

    $resizedImagePath = "$PSScriptRoot\..\site\src\components\Playlist\cover-art\$playlistType\FullSizeBackup\$cityImagePath"+"_resized.jpg";
    $smallImageOutputPath = "$PSScriptRoot\..\site\src\components\Playlist\cover-art\$playlistType\$cityImagePath.jpg";
    Move-Item $resizedImagePath $smallImageOutputPath -Force
}

function Resize-CoverArtImage([PlaylistType] $playlistType, [string] $city)
{
    $cityImagePath = $city -replace '\s','' -replace ',',''
    $outputPath = "$PSScriptRoot\..\site\src\components\Playlist\cover-art\$playlistType\FullSizeBackup\$cityImagePath.jpg";
    
    Resize-Image -ImagePath $outputPath -MaintainRatio -Width 400

    $resizedImagePath = "$PSScriptRoot\..\site\src\components\Playlist\cover-art\$playlistType\FullSizeBackup\$cityImagePath"+"_resized.jpg";
    $smallImageOutputPath = "$PSScriptRoot\..\site\src\components\Playlist\cover-art\$playlistType\$cityImagePath.jpg";
    Move-Item $resizedImagePath $smallImageOutputPath -Force
}