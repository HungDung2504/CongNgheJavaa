$tomcatUrl = "https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.30/bin/apache-tomcat-10.1.30.zip"
$tomcatZip = "apache-tomcat-10.1.30.zip"
$tomcatDir = "apache-tomcat-10.1.30"

if (-not (Test-Path $tomcatDir)) {
    Write-Host "Downloading Tomcat 10..."
    curl.exe -L -o $tomcatZip $tomcatUrl
    Write-Host "Extracting Tomcat 10..."
    Expand-Archive -Path $tomcatZip -DestinationPath "." -Force
}

Write-Host "Deploying Nexora to Tomcat..."
# Remove existing ROOT
if (Test-Path "$tomcatDir\webapps\ROOT") {
    Remove-Item -Recurse -Force "$tomcatDir\webapps\ROOT"
}
if (Test-Path "$tomcatDir\webapps\ROOT.war") {
    Remove-Item -Force "$tomcatDir\webapps\ROOT.war"
}

Copy-Item -Path ".\target\nexora.war" -Destination "$tomcatDir\webapps\ROOT.war" -Force

Write-Host "Starting Tomcat..."
$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-25.0.4.101-hotspot"
$env:CATALINA_HOME = (Resolve-Path $tomcatDir).Path

# Run Tomcat in the current console so we can see logs
& "$tomcatDir\bin\catalina.bat" run
