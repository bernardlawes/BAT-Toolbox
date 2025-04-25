Import-Module VirtualDesktop

# === Add Win32 API for window title detection ===
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Win32 {
    [DllImport("user32.dll")]
    public static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, IntPtr lParam);
    public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);

    [DllImport("user32.dll")]
    public static extern int GetWindowText(IntPtr hWnd, System.Text.StringBuilder text, int count);

    [DllImport("user32.dll")]
    public static extern bool IsWindowVisible(IntPtr hWnd);
}
"@

function Get-WindowByTitle($partialTitle) {
    $refWindows = [System.Collections.Generic.List[System.IntPtr]]::new()

    $null = [Win32]::EnumWindows({
        param($hWnd, $lParam)

        if (-not [Win32]::IsWindowVisible($hWnd)) { return $true }

        $builder = New-Object System.Text.StringBuilder 256
        [void][Win32]::GetWindowText($hWnd, $builder, $builder.Capacity)
        $title = $builder.ToString()

        if ($title.Length -gt 0) {
            Write-Host "Checking window: '$title'"
            if ($title -like "*$partialTitle*") {
                Write-Host "Match found for: '$partialTitle'"
                $refWindows.Add($hWnd)
            }
        }

        return $true
    }, [IntPtr]::Zero)

    return $refWindows
}

# === Load config ===
$configPath = Join-Path $PSScriptRoot "config.json"
$config = Get-Content $configPath | ConvertFrom-Json

# === Ensure required virtual desktops exist ===
$neededIndexes = ($config.apps | Where-Object { $_.enabled -and $_.virtualDesktop }) |
                 ForEach-Object { [int]$_.virtualDesktop - 1 } |
                 Sort-Object -Unique

$existingDesktops = Get-Desktop
$currentCount = $existingDesktops.Count

foreach ($index in $neededIndexes) {
    if ($index -ge $currentCount) {
        $toCreate = ($index + 1) - $currentCount
        for ($i = 0; $i -lt $toCreate; $i++) {
            New-Desktop | Out-Null
        }
        Write-Host "Created $toCreate virtual desktop(s) to reach index $index"
        $currentCount += $toCreate
    }
}

# === Process each app ===
foreach ($app in $config.apps) {
    if (-not $app.enabled) { continue }
    if ($app.virtualDesktop -eq $null) { continue }

    try {
        $desktopIndex = [int]$app.virtualDesktop - 1
        $target = Get-Desktop -Index $desktopIndex

        if ($app.type -eq "uwp") {
            Start-Sleep -Seconds 4

            $titleToMatch = if ($app.PSObject.Properties["matchTitle"]) { $app.matchTitle } else { $app.name }
            Write-Host "`n--- Searching for UWP window matching: '$titleToMatch' ---"
            $windows = Get-WindowByTitle $titleToMatch

            if ($windows.Count -eq 0) {
                Write-Host "No matching window found for '$titleToMatch'"
            }
            elseif (-not $target) {
                Write-Host "Virtual desktop target is null for index $desktopIndex (requested: $($app.virtualDesktop))"
            }
            else {
                $hWnd = $windows[0]
                Write-Host "Attempting to move window handle: $hWnd to Virtual Desktop index: $desktopIndex"
                Move-Window -Hwnd $hWnd -Desktop $target
                Write-Host "Successfully moved window '$titleToMatch' to Virtual Desktop $($app.virtualDesktop)"
            }

        } else {
            $procName = [System.IO.Path]::GetFileNameWithoutExtension($app.path)
            $process = Get-Process $procName -ErrorAction SilentlyContinue |
                       Where-Object { $_.MainWindowHandle -ne 0 } |
                       Select-Object -First 1

            if ($process -and $target) {
                [IntPtr]$hwnd = $process.MainWindowHandle
                Move-Window -Hwnd $hwnd -Desktop $target
                Write-Host "Moved process '$procName' to Virtual Desktop $($app.virtualDesktop)"
            } else {
                if (-not $process) {
                    Write-Host "Process '$procName' not found or no window"
                }
                if (-not $target) {
                    Write-Host "Virtual Desktop index $desktopIndex not found"
                }
            }
        }
    }
    catch {
        Write-Host "Error processing app '$($app.name)': $($_.Exception.Message)"
    }
}
