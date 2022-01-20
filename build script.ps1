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


#PreAdd FW rules java run times
$ListOfPaths=@()

$ListOfPaths+=Get-ChildItem -Path "C:\program files\openjdk" -Filter java.exe  -Recurse
$ListOfPaths+=Get-ChildItem -Path "$home\.vscode" -Filter java.exe  -Recurse

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


#Copy Hackathon Files ...
Invoke-WebRequest -UseBasicParsing -Uri "https://github.com/djr1991/Java_wth_VM/raw/main/spring-petclinic.zip" -OutFile petclinic.zip
mkdir $home\desktop\petclinic -force
Expand-Archive -Path petclinic.zip -DestinationPath $home\desktop\petclinic



#Create a shortcut to the command prompt
$SourceFilePath = "C:\windows\system32\cmd.exe"
$ShortcutPath = "$home\desktop\Command Prompt.lnk"
$WScriptObj = New-Object -ComObject ("WScript.Shell")
$shortcut = $WscriptObj.CreateShortcut($ShortcutPath)
$shortcut.TargetPath = $SourceFilePath
$shortcut.Save()


Stop-Transcript
