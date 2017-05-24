# Winlogbeat scripts and configuration folder

- "__configure.ps1__" is script that downloads latest winlogbeat and installs it on local windows machine with preffered install location from [winlogbeat reference documentation](https://www.elastic.co/guide/en/beats/winlogbeat/current/winlogbeat-installation.html)

- "__install.ps1__" is script that copies yml configuration and certificate into installation folder of winlogbeat. Also it loads index for winlogbeat into elasticsearch and imports dashboards for winlogbeat.

### Get started

1. Run "install.ps1" script in powershell to download winlogbeat
2. Run "configure.ps1" script in powershell to configure winlogbeat with latest configuration from this repository
3. Go to Windows services and manually start Winlogbeat