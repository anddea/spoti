Write-Host "Modifying Spotify!"
Set-Location $env:APPDATA/Spotify/Apps
Copy-Item xpui.spa xpui.bak

Add-Type -Assembly 'System.IO.Compression.FileSystem'
$zip = [System.IO.Compression.ZipFile]::Open("$env:APPDATA\Spotify\Apps\xpui.spa", 'update')
$entry_xpui = $zip.GetEntry('xpui.js')
$reader = New-Object System.IO.StreamReader($entry_xpui.Open())
$xpui_js = $reader.ReadToEnd()
$reader.Close()

$xpui_js_new = $xpui_js -replace 'adsEnabled:!0', 'adsEnabled:!1' -replace 'allSponsorships' , '' -replace 'i=e=>"free"', 'i=e=>"premium"' -replace 's=e=>"premium"', 's=e=>"free"' -replace 'withQueryParameters\(e\){return this.queryParameters=e,this}', 'withQueryParameters(e){return this.queryParameters=(e.types?{...e, types: e.types.split(",").filter(_ => !["episode","show"].includes(_)).join(",")}:e),this}' -replace ',this[.]enableShows=[a-z]', ''

$writer = New-Object System.IO.StreamWriter($entry_xpui.Open())
$writer.BaseStream.SetLength(0)
$writer.Write($xpui_js_new)
$writer.Flush()
$writer.Close()

$zip.Dispose()

Write-Host "Spotify modified! Closing in a sec..."
Start-Sleep -Seconds 1.5
