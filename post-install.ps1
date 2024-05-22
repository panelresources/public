Write-Host "Now running Post-Install script"

wsl --install -d Ubuntu-22.04
wsl --set-default Ubuntu-22.04

# Set the path to your Dockerfile (adjust as needed)
$dockerfilePath = "$env:USERPROFILE\Documents\GitHub\edbot"

# Set the desired image name and tag
$imageName = "edbot_test"

$env:Path += ";C:\Program Files\Docker\Docker\resources\bin\"
# Build the Docker image
docker build -t $imageName -f $dockerfilePath .
docker run -it --rm -d -v $env:USERPROFILE\Documents\GitHub\edbot\:/app -v \wsl.localhost\Ubuntu-22.04\mnt\wslg:/tmp -p 80:80 -p 1883:1883 -p 9001:9001 edbot_test

