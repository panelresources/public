# Starting the installation script for Edbot
Write-Host "Starting the installation script for Edbot"
Write-Host "Git Clone the Edbot Repository"

$credentials = Read-Host "Enter your GitHub Personal Access Token"
$repo = "panelresources/edbot"
$targetDirectory = "$env:USERPROFILE\Documents\GitHub\edbot"

# Construct the URL for the zipball (archive)
$zipUrl = "https://api.github.com/repos/$repo/zipball/main"

# Download the zipball
$zipFilePath = "$targetDirectory\repo.zip"
Invoke-WebRequest -Uri $zipUrl -Headers @{ "Authorization" = "token $credentials" } -OutFile $zipFilePath

# Extract the zip file
Expand-Archive -Path $zipFilePath -DestinationPath $targetDirectory

# Delete the zip file
Remove-Item -Path $zipFilePath

Write-Host "Repository downloaded, extracted, and zip file deleted successfully!"



# Install WSL 2
wsl --install

# Set WSL 2 as the default version
wsl --set-default-version 2
wsl --install -d Ubuntu-22.04
wsl --set-default Ubuntu-22.04


Write-Host "Download and Install Docker Desktop"
# Download the Docker Desktop installer
$installerUrl = "https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe"
$installerPath = "$env:TEMP\DockerDesktopInstaller.exe"

Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath

# Install Docker Desktop silently
Start-Process -FilePath $installerPath -ArgumentList "install --quiet" -Wait -NoNewWindow

# Clean up the installer
Remove-Item -Path $installerPath


#if (-not (Get-Command choco.exe -ErrorAction SilentlyContinue)) {
#    Set-ExecutionPolicy Bypass -Scope Process -Force
#    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
#    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
#}

# List of packages to install
#$packages = 'git'

# Install each package silently
#foreach ($package in $packages) {
#    choco install $package -y
#}


# Set the path to your Dockerfile (adjust as needed)
$dockerfilePath = "$env:USERPROFILE\Documents\GitHub\edbot"

# Set the desired image name and tag
$imageName = "edbot_test"


# Build the Docker image
docker build -t $imageName -f $dockerfilePath .

docker run -it --rm -d -v $env:USERPROFILE\Documents\GitHub\edbot\:/app -v \wsl.localhost\Ubuntu-22.04\mnt\wslg:/tmp -p 80:80 -p 1883:1883 -p 9001:9001 edbot_test
