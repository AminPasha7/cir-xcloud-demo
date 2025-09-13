$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$src  = Join-Path $root "app"
$zip  = Join-Path $root "lambda.zip"
if (Test-Path $zip) { Remove-Item $zip -Force }
Push-Location $src
python -m pip install --target . .
# no deps needed; keep structure for future
Compress-Archive -Path * -DestinationPath $zip -Force
Pop-Location
Write-Host "Built $zip"
