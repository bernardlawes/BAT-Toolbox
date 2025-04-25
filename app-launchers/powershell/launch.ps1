# Load config
$jsonPath = Join-Path $PSScriptRoot "config.json"
$config = Get-Content $jsonPath | ConvertFrom-Json

# === Launch Tab Groups ===
$tabGroups = $config.tabGroups
foreach ($group in $tabGroups.PSObject.Properties) {
    if ($group.Name -like "_*") { continue }

    $tabs = $group.Value
    $args = @("--new-window") + $tabs
    Start-Process "msedge.exe" -ArgumentList $args
    Start-Sleep -Seconds 2
}

# === Launch Apps with settings ===
foreach ($app in $config.apps) {
    if (-not $app.enabled) { continue }
    if ($app.name -like "_*") { continue }

    # Delay before launching (default 1s if missing)
    $delay = if ($app.delay) { $app.delay } else { 1 }
    Start-Sleep -Seconds $delay

    # Basic launch (type handling could be expanded later)
    Start-Process $app.path

    # Placeholder for future virtual desktop logic
    Write-Output "Launched $($app.name) on Virtual Desktop $($app.virtualDesktop)"
}
