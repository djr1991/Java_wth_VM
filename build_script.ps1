#Prereqs
$ErrorActionPreference="SilentlyContinue"
$LogPath = 'C:\WindowsAzure\Logs\deploydeveloperconfig.log'
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"
Start-Transcript -path $LogPath -append
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))


#Install Apps
choco install "openjdk8" --confirm
choco install "maven" --confirm --force
choco install "vscode" --confirm --force
start-process "C:\Program Files\Microsoft VS Code\bin\Code" -ArgumentList "--install-extension vscjava.vscode-java-pack"
choco install "azure-cli" --confirm
choco install "git" --confirm

#Add Maven to Global Path Environment Variable
$MavenBinPath=(Get-ChildItem -Path "C:\ProgramData\chocolatey\lib\maven" -Filter "bin" -Recurse).FullName
[Environment]::SetEnvironmentVariable("PATH", $Env:PATH + ";$MavenBinPath", [EnvironmentVariableTarget]::Machine)


# Set AZ CLI enviromental variables
[Environment]::SetEnvironmentVariable("PATH", $Env:PATH + ";C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin", [EnvironmentVariableTarget]::Machine)

# Set JAVA enviromental variables
$javaPath=(Get-ChildItem -Path "C:\program files\openjdk" -Directory).fullname
[Environment]::SetEnvironmentVariable("PATH", $Env:PATH + ";$javaPath\bin", [EnvironmentVariableTarget]::Machine)

# Set Git enviromental variables
[Environment]::SetEnvironmentVariable("PATH", $Env:PATH + ";C:\Program Files\Git\bin", [EnvironmentVariableTarget]::Machine)



#PreAdd FW rules java run times
$ListOfPaths=@()

$ListOfPaths+=Get-ChildItem -Path "C:\program files\openjdk" -Filter java.exe  -Recurse
$ListOfPaths+=Get-ChildItem -Path "c:\users\adminUsername\.vscode" -Filter java.exe  -Recurse

$ListOfPaths | foreach {

    $ruletcp=@{
    
        
        DisplayName="Java-$($_.VersionInfo.ProductName)-$($_.VersionInfo.ProductVersion)-TCP" 
        Description="Allow $($_.VersionInfo.Product) server apps"
        Protocol="TCP"
        Enabled="True"
        Profile="Any"
        Action="Allow"
        Program=$_.FullName
    }
    $ruleudp=@{
    
        
        DisplayName="Java-$($_.VersionInfo.ProductName)-$($_.VersionInfo.ProductVersion)-UDP" 
        Description="Allow $($_.VersionInfo.ProductName) server apps"
        Protocol="UDP"
        Enabled="True"
        Profile="Any"
        Action="Allow"
        Program=$_.FullName
    }       

    New-NetFirewallRule @ruletcp
    New-NetFirewallRule @ruleudp


}

#Set a Custom RDP Port
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -name "fDenyTSConnections" -Value  0
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "PortNumber" -Value 22389
New-NetFirewallRule -DisplayName 'RDPPORTLatest' -Profile 'Any' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 22389
Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile' -name "AllowLocalPolicyMerge" -Value 1

reg query "HKLM\Software\Policies\Microsoft\WindowsFirewall\PublicProfile" /s
Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "PortNumber"
Get-NetFirewallProfile -PolicyStore ActiveStore


#Copy Hackathon Files ...
Invoke-WebRequest -UseBasicParsing -Uri "https://github.com/djr1991/Java_wth_VM/raw/main/spring-petclinic.zip" -OutFile petclinic.zip
mkdir c:\users\adminusername\desktop\petclinic -force
Expand-Archive -Path petclinic.zip -DestinationPath c:\users\adminusername\desktop\petclinic



#Create a shortcut to the command prompt
$SourceFilePath = "C:\windows\system32\cmd.exe"
$ShortcutPath = "c:\users\adminusername\desktop\Command Prompt.lnk"
$WScriptObj = New-Object -ComObject ("WScript.Shell")
$shortcut = $WscriptObj.CreateShortcut($ShortcutPath)
$shortcut.TargetPath = $SourceFilePath
$shortcut.Save()


Stop-Transcript
