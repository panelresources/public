# Prompt the user for their GitHub Personal Access Token
$credentials = Read-Host "Enter your GitHub Personal Access Token"

# Specify the repository and target directory
$repo = "panelresources/edbot"
$targetDirectory = "$env:USERPROFILE\Documents\GitHub\edbot"

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
