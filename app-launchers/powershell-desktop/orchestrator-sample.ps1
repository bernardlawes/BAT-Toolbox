Import-Module VirtualDesktop

# Move Notepad to desktop 2
$process = Get-Process notepad -ErrorAction SilentlyContinue
if ($process -and $process.MainWindowHandle -ne 0) {
    $vd = Get-Desktop -Index 1  # virtualDesktop: 2 (0-based index)
    Move-Window -Hwnd $process.MainWindowHandle -Desktop $vd
    Write-Host "Moved Notepad to virtual desktop 2"
} else {
    Write-Host "Notepad not found or no main window"
}
