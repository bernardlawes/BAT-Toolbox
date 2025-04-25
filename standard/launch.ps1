# Read and parse tabGroups.json
$jsonPath = Join-Path $PSScriptRoot "launch.json"
$tabGroups = Get-Content $jsonPath | ConvertFrom-Json

# For each group, open a new Edge window with those tabs
foreach ($group in $tabGroups.PSObject.Properties) {

    if ($group.Name -like "_*") {
        continue  # skip groups with names starting with underscore
    }
    
    $tabs = $group.Value
    $args = @("--new-window") + $tabs
    Start-Process "msedge.exe" -ArgumentList $args
    Start-Sleep -Seconds 2
}

# Launch Microsoft To Do
Start-Sleep -Seconds 2
Start-Process "shell:AppsFolder\Microsoft.Todos_8wekyb3d8bbwe!App"

# Launch Microsoft Calendar
Start-Sleep -Seconds 2
Start-Process "shell:AppsFolder\microsoft.windowscommunicationsapps_8wekyb3d8bbwe!microsoft.windowslive.calendar"

# Launch VS Code
Start-Sleep -Seconds 2
Start-Process "C:\Users\berna\AppData\Local\Programs\Microsoft VS Code\Code.exe"


