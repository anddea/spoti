if (Test-Path -Path $env:APPDATA/Spotify/Apps) {
  Set-Location $env:APPDATA/Spotify/Apps
} else {
  Write-Host "Install Spotify from the website!`nhttps://www.spotify.com/download/" -ForegroundColor Red
  break
}

Write-Host "Modifying Spotify!"
Copy-Item xpui.spa xpui.bak

Add-Type -Assembly 'System.IO.Compression.FileSystem'
$zip = [System.IO.Compression.ZipFile]::Open("$env:APPDATA\Spotify\Apps\xpui.spa", 'update')
$entry_xpui = $zip.GetEntry('xpui.js')
$reader = New-Object System.IO.StreamReader($entry_xpui.Open())
$xpui_js = $reader.ReadToEnd()
$reader.Close()

$xpui_js_new = $xpui_js -replace 'adsEnabled:!0', 'adsEnabled:!1' -replace 'allSponsorships' , '' -replace '(.=.=>)"free"', '$1"premium"'

$writer = New-Object System.IO.StreamWriter($entry_xpui.Open())
$writer.BaseStream.SetLength(0)
$writer.Write($xpui_js_new)
$writer.Flush()
$writer.Close()

$zip.Dispose()

Write-Host "Spotify modified! Closing in a sec..."
Start-Sleep -Seconds 1.5
