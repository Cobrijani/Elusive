# Firewall filebeat scripts and configuration folder [DEPRECATED]

Folder filebeat contains configuration that is needed to process firewall logs

- "__install.ps1__" is script that downloads latest filebeat and installs it on local windows machine with preffered install location from [filebeat reference documentation](https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-installation.html)

- "__configure.ps1__" is script that copies yml configuration and certificate into installation folder of filebeat. Also it loads index for filebeat into elasticsearch and imports dashboards for filebeat.

### Get started

1. Run "install.ps1" script in powershell to download filebeat
2. Run "configure.ps1" script in powershell to configure filebeat with latest configuration from this repository
3. Go to Windows services and manually start filebeat

### Windows firewall logs

1. Open Windows Firewall
2. Click on Advanced Settings
3. Click on Windows Firewall With Advanced Security on Local Computer
4. On Actions area click on Properties
5. Click on Domain Profile tab
6. Click on Logging Customize
7. Set name to: %systemroot%\system32\LogFiles\Firewall\pfirewall.log
8. Log dropped packets and Log successfull connections set to Yes
9. Repeat 6-8 for Public and Private Profile tab
10. Repeat 1. and 2.
11. Go to Outbound Rules
12. Click on New Rule in Actions arena
13. Click on Port and Next
14. Click on TCP, Specific remote ports
15. Set Specific remote ports to: 5678-5680
16. Click on Block this connections
17. Mark Domain, Public and Private
18. Set name and click Finish
19. After this Kibana will show all successfull and unsuccessfull firewall logs
20. We specify rule to block outbound on ports 5678-5680
21. If you want to fire this event go to: https://www.google.rs:5678/ 

