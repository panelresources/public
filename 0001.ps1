# Display some text
Write-Host "Starting the installation script for Edbot"

# Specify the GitHub repository URL
$repoUrl = "https://github.com/ironmansoftware/plinqo"

# Download the repository ZIP file
Invoke-WebRequest -Uri "$repoUrl/archive/refs/heads/main.zip" -OutFile "plinqo.zip"

# Extract the ZIP file
Expand-Archive -Path "plinqo.zip" -DestinationPath "."

# Rename the extracted folder
Rename-Item -Path ".\plinqo-main" -NewName "plinqo"

# Clean up the ZIP file
Remove-Item -Path "plinqo.zip"
