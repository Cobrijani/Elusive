##########
# Winlogbeat automatic configuration script
# Author: Stefan Bratic <cobrijani@gmail.com>
# Version: 1.0, 2017-05-23
##########

# Ask for elevated permissions if required
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $args" -Verb RunAs
	Exit
}
$wlb_dir = "C:\Program Files\Winlogbeat"

$conf_in = "$PSScriptRoot\winlogbeat.yml"
$conf_out = "$($wlb_dir)\winlogbeat.yml"

$cert_in_bk = "$PSScriptRoot\certs\beats.key"
$cert_out_bk = "$($wlb_dir)\beats.key"

$cert_in_bp = "$PSScriptRoot\certs\beats.pem"
$cert_out_bp = "$($wlb_dir)\beats.pem"

$cert_in_ca = "$PSScriptRoot\certs\ca.pem"
$cert_out_ca = "$($wlb_dir)\ca.pem"

function Main {
    Copy-Item $conf_in $conf_out -Force
    Copy-Item $cert_in_bk $cert_out_bk -Force
    Copy-Item $cert_in_bp $cert_out_bp -Force
    Copy-Item $cert_in_ca $cert_out_ca -Force
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
    Invoke-WebRequest -Method Put -InFile "C:\\Program Files\Winlogbeat\winlogbeat.template.json" -Uri  http://localhost:9200/_template/winlogbeat?pretty -ContentType application/json
}

Main