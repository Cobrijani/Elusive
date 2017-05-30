# Firewall filebeat scripts and configuration folder

- "__install.ps1__" is script that downloads latest filebeat and installs it on local windows machine with preffered install location from [filebeat reference documentation](https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-installation.html)

- "__configure.ps1__" is script that copies yml configuration and certificate into installation folder of filebeat. Also it loads index for filebeat into elasticsearch and imports dashboards for filebeat.

### Get started

1. Run "install.ps1" script in powershell to download filebeat
2. Run "configure.ps1" script in powershell to configure filebeat with latest configuration from this repository
3. Go to Windows services and manually start filebeat