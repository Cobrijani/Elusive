##########
# Firewall filebeat automatic installation script
# Author: Milorad Vojnovic <milekuglas@gmail.com>
# Version: 1.0, 2017-05-30
##########

# Ask for elevated permissions if required
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $args" -Verb RunAs
	Exit
}

Write-Output "Powershell V: $($PSVersionTable.PSVersion)"
Add-Type -AssemblyName System.IO.Compression.FileSystem

$version = "5.4.0"
$unzip_file_name = "filebeat-$($version)-windows-x86_64"
$zip_file_name = "$($unzip_file_name).zip"
$download_url = "https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$($version)-windows-x86_64.zip"
$download_out = "$PSScriptRoot\$($zip_file_name)"
$unzip_out = "C:\Program Files"
#$unzip_out = "$PSScriptRoot\unzip"
$renamed_file_name = "Filebeat"


#Main execution func
function Main {
    Download $download_url $download_out
    Unzip $download_out $unzip_out
    RunPS1 "$($unzip_out)\$($renamed_file_name)\install-service-filebeat.ps1"
    WaitForKey
}

#download file
Function Download {
    param([string]$url, [string] $output)
    $start_time = Get-Date
    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile($url, $output)
    Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s), Download complete. Output: $($output)"
}
#unzip it and rename it
Function Unzip {
    param([string]$zipfile, [string] $outpath)
    Write-Output "Unzip start"

    #delete content where will be saved
    # If (Test-Path $outpath) {
    #     Remove-Item $outpath
    # }

    #Expand-Archive $zipfile -DestinationPath $outpath
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
    Rename-Item "$($unzip_out)\$($unzip_file_name)" $renamed_file_name
    Write-Output "Unzip complete"
}

#Run wanted script
function RunPS1{
    param([string] $path)
    Write-Output "Ps1 path: $($path)"
    Invoke-Expression "& `"$($path)`""
}

Function WaitForKey {
    Write-Host
    Write-Host "Press any key to continue..." -ForegroundColor Black -BackgroundColor White
    [Console]::ReadKey($true) | Out-Null
}


Main
