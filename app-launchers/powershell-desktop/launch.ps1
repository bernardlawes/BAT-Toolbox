# Edge Tab groups
# Configurable app launching
# Per-app: enabled, delay, type, virtualDesktop
# Automatic creation of virtual desktops if needed
# Optional fallback if VirtualDesktop module is missing
# A full session log written to a .log file in the same folder as the script
# Timestamps for each action
# Errors or skipped apps clearly noted
# Summary of virtual desktop movements

# === Setup logging ===
$logPath = Join-Path $PSScriptRoot "launch.log"
"" | Out-File $logPath

function Log {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $args" | Out-File $logPath -Append
}

Log "=== Launch from config started ==="

# === Load config.json ===
$jsonPath = Join-Path $PSScriptRoot "config.json"
try {
    $config = Get-Content $jsonPath | ConvertFrom-Json
    Log "Loaded config.json successfully"
}
catch {
    Log "ERROR loading config.json: $_"
    exit 1
}

# === Launch tab groups ===
foreach ($group in $config.tabGroups.PSObject.Properties) {
    if ($group.Name -like "_*") {
        Log "Skipped tab group '$($group.Name)'"
        continue
    }

    $tabs = $group.Value
    $args = @("--new-window") + $tabs
    Start-Process "msedge.exe" -ArgumentList $args
    Log "Launched tab group '$($group.Name)' with tabs: $($tabs -join ', ')"
    Start-Sleep -Seconds 2
}

# === Launch apps ===
foreach ($app in $config.apps) {
    if (-not $app.enabled) {
        Log "Skipped app '$($app.name)' (disabled)"
        continue
    }

    $delay = if ($app.delay) { $app.delay } else { 1 }
    Start-Sleep -Seconds $delay

    try {
        Start-Process $app.path
        Log "Launched app '$($app.name)' with path: $($app.path)"
    }
    catch {
        Log "ERROR launching app '$($app.name)': $_"
    }
}

Log "=== Launch complete ==="

# Open log file
if ((Get-Content $logPath | Select-String -Pattern "ERROR|Error|Exception")) {
    Start-Process notepad.exe $logPath
}

Start-Sleep -Seconds 5  # Let the apps fully open first
powershell -ExecutionPolicy Bypass -File "$PSScriptRoot\orchestrator.ps1"

