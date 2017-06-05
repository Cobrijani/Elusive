##########
# Firewall filebeat automatic installation script
# Author: Arsenije Vladisavljev <arsenije.vladisavljev@gmail.com>
# Version: 1.0, 2017-05-30
##########

# Ask for elevated permissions if required
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $args" -Verb RunAs
	Exit
}
$wlb_dir = "C:\Program Files\FilebeatApp"

$conf_in = "$PSScriptRoot\filebeat.yml"
$conf_out = "$($wlb_dir)\filebeat.yml"

$cert_in = "$PSScriptRoot\logstash-beats.crt"
$cert_out = "$($wlb_dir)\logstash-beats.crt"

function Main {
    Copy-Item $conf_in $conf_out -Force
    Copy-Item $cert_in $cert_out -Force
    LoadTemplate
    ImportDashboards
    WaitForKey
}

function ImportDashboards{
    Write-Host "Importing dashboards"
    Invoke-Expression "& `"$($wlb_dir)\scripts\import_dashboards.exe`""
}

Function WaitForKey {
    Write-Host
    Write-Host "Press any key to continue..." -ForegroundColor Black -BackgroundColor White
    [Console]::ReadKey($true) | Out-Null
}

function LoadTemplate{
    Write-Host "Loading templates into elasticsearch"
    
	$user = "elastic"
	$pass = "changeme"
	$secPass = convertTo-secureString $pass -AsPlainText -Force
	$cred = New-Object System.Management.Automation.PSCredential($user,$secPass)
    Invoke-WebRequest -Method Put -InFile "C:\\Program Files\FilebeatApp\filebeat.template.json" -Uri  http://localhost:9200/_template/filebeat?pretty -ContentType application/json -Credential $cred
}

Main