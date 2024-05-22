# Display some text
Write-Host "Starting the installation script for Edbot"

# Specify the GitHub repository URL
$repoUrl = "https://github.com/ironmansoftware/plinqo"

# Download the repository ZIP file
Invoke-WebRequest -Uri "$repoUrl/archive/refs/heads/main.zip" -OutFile "plinqo.zip"

# Extract the ZIP file
Expand-Archive -Path "plinqo.zip" -DestinationPath "."


# Download the Docker Desktop installer
$installerUrl = "https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe"
$installerPath = "$env:TEMP\DockerDesktopInstaller.exe"

Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath

# Install Docker Desktop silently
Start-Process -FilePath $installerPath -ArgumentList "install --quiet" -Wait -NoNewWindow

# Clean up the installer
Remove-Item -Path $installerPath



if (-not (Get-Command choco.exe -ErrorAction SilentlyContinue)) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# List of packages to install
$packages = 'git'

# Install each package silently
foreach ($package in $packages) {
    choco install $package -y
}
