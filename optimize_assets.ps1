$root = "assets"
$maxW = 512
$q    = 82

$before = (Get-ChildItem -Recurse -Path $root -Include *.png,*.jpg,*.jpeg |
           Measure-Object Length -Sum).Sum
"Antes: {0:N2} MB" -f ($before/1MB)

Get-ChildItem -Recurse -Path $root -Include *.png,*.jpg,*.jpeg | ForEach-Object {
    $out = [System.IO.Path]::ChangeExtension($_.FullName, ".webp")
    Write-Host "Convirtiendo $($_.Name)..."
    ffmpeg -y -loglevel error -i $_.FullName -vf "scale='min($maxW,iw)':-2" -c:v libwebp -quality $q $out
}

$after = (Get-ChildItem -Recurse -Path $root -Include *.webp |
          Measure-Object Length -Sum).Sum
"Despues: {0:N2} MB" -f ($after/1MB)
"Ahorro:  {0:N2} MB" -f (($before-$after)/1MB)
