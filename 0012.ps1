# Starting the installation script for Edbot
Write-Host "Starting the installation script for Edbot"
Write-Host "Git Clone the Edbot Repository"

# Prompt the user for their GitHub Personal Access Token
$credentials = Read-Host "Enter your GitHub Personal Access Token"

# Specify the repository and target directory
$repo = "panelresources/edbot"
$targetDirectory = "$env:USERPROFILE\Documents\GitHub"

# Create the target directory if it doesn't exist
if (-not (Test-Path $targetDirectory)) {
    New-Item -ItemType Directory -Path $targetDirectory | Out-Null
    if (Test-Path $targetDirectory) {
        Write-Host "Directory created successfully at $targetDirectory"
    } else {
        Write-Host "Failed to create the directory"
        exit 1
    }
}

# Construct the URL for the zipball (archive)
$zipUrl = "https://api.github.com/repos/$repo/zipball/main"

# Specify the path for the downloaded zip file
$zipFilePath = Join-Path -Path $targetDirectory -ChildPath "repo.zip"

# Download the zipball
Invoke-WebRequest -Uri $zipUrl -Headers @{ "Authorization" = "token $credentials" } -OutFile $zipFilePath

# Extract the zip file to the target directory
Expand-Archive -Path $zipFilePath -DestinationPath $targetDirectory

# Get the name of the top-level directory
$extractedDirName = Get-ChildItem -Path $targetDirectory | Select-Object -First 1

# Rename the top-level directory to 'edbot'
Rename-Item -Path (Join-Path -Path $targetDirectory -ChildPath $extractedDirName) -NewName "edbot"

# Delete the zip file
Remove-Item -Path $zipFilePath

Write-Host "Repository downloaded, extracted, and top-level directory renamed to 'edbot' successfully!"

dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Install WSL 2
wsl --install

# Set WSL 2 as the default version
wsl --set-default-version 2
wsl --install -d Ubuntu-22.04
#wsl --set-default Ubuntu-22.04


Write-Host "Download and Install Docker Desktop"
# Download and Install Docker Desktop
$installerUrl = "https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe"
$installerPath = "$env:TEMP\DockerDesktopInstaller.exe"

# Download the Docker Desktop installer
Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath

# Install Docker Desktop silently with auto-acceptance of the license
Start-Process -FilePath $installerPath -ArgumentList "install --quiet --accept-license" -Wait -NoNewWindow

# Clean up the installer
Remove-Item -Path $installerPath




# Set the path to your Dockerfile (adjust as needed)
$dockerfilePath = "$env:USERPROFILE\Documents\GitHub\edbot"

# Set the desired image name and tag
$imageName = "edbot_test"

$env:Path += ";C:\Program Files\Docker\Docker\resources\bin\"
# Build the Docker image
docker build -t $imageName -f $dockerfilePath .
docker run -it --rm -d -v $env:USERPROFILE\Documents\GitHub\edbot\:/app -v \wsl.localhost\Ubuntu-22.04\mnt\wslg:/tmp -p 80:80 -p 1883:1883 -p 9001:9001 edbot_test
