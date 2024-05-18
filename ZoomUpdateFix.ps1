# Set script to stop on error
$ErrorActionPreference = "Stop"

# Function to handle errors
function Handle-Error {
    param (
        [string]$errorMessage
    )
    Write-Output "Error: $errorMessage"
    Write-Output "Error Details: $($PSItem.Exception.Message)"
    exit 1
}

# Function to download and install Zoom
function Update-Zoom {
    # Define the paths
    $downloadFolder = "C:\temp_zoom"
    $installerPath = "$downloadFolder\ZoomInstaller.exe"
    
    # Create download folder if it does not exist
    if (-not (Test-Path $downloadFolder)) {
        New-Item -Path $downloadFolder -ItemType Directory | Out-Null
    }
    
    # URL for downloading the latest Zoom client
    $downloadUrl = "https://zoom.us/client/latest/ZoomInstaller.exe"
    
    # Download the latest Zoom installer
    try {
        Write-Output "Downloading Zoom installer..."
        Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath
    } catch {
        Handle-Error -errorMessage "Failed to download Zoom installer."
    }
    
    # Check if the installer was downloaded
    if (-not (Test-Path $installerPath)) {
        Handle-Error -errorMessage "Zoom installer was not downloaded correctly."
    }
    
    # Execute the installer
    try {
        Write-Output "Installing Zoom..."
        Start-Process -FilePath $installerPath -Args "/quiet" -Wait
    } catch {
        Handle-Error -errorMessage "Installation of Zoom failed."
    }
    
    Write-Output "Zoom has been updated successfully."
}

# Main script execution
try {
    Update-Zoom
} finally {
    # Clean up download directory
    Remove-Item -Path "C:\temp_zoom" -Recurse -Force
}

# Exit script
exit
