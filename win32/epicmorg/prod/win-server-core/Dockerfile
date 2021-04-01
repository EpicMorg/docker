FROM mcr.microsoft.com/windows/servercore:20H2
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"

ENV chocolateyUseWindowsCompression false

####################################################################################################################################
# https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-docker/manage-windows-dockerfile
####################################################################################################################################

##################################################################
#                   Installing IIS
##################################################################
RUN powershell -Command  Add-WindowsFeature Web-Server;  \
    Invoke-WebRequest -UseBasicParsing -Uri "https://dotnetbinaries.blob.core.windows.net/servicemonitor/2.0.1.10/ServiceMonitor.exe" -OutFile "C:\ServiceMonitor.exe"

##################################################################
#                   Installing ocolatey.org
##################################################################
RUN powershell -Command \
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
	iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

##################################################################
#                   install vcredist packages
##################################################################
RUN cinst --no-progress  -y  -IgnoreChecksums \
    vcredist-all \
    vcredist140 \
    vcredist2005 \
    vcredist2008 \
    vcredist2010 \
    vcredist2012 \
    vcredist2013 \
    vcredist2013 \
    vcredist2015

##################################################################
#                   install dotnet packages
##################################################################
RUN cinst --no-progress  -y  -IgnoreChecksums \
    dotnet \
    dotnet-aspnetruntime \
    dotnet-windowshosting \
    dotnet-runtime \
    dotnet-sdk \
    dotnetfx \
    powershell-core
 
##################################################################
#                   install base packages
##################################################################
RUN cinst --no-progress  -y  -IgnoreChecksums \
    curl \
    far \
    findutils \
    git \
    make \
    mc \
    nano \
    openssl \
    sed \
    steamcmd \
    sudo \
    tartool \
    unrar \
    unzip \
    wget

##################################################################
#                   install archive packages
##################################################################
RUN cinst --no-progress  -y  -IgnoreChecksums \
    7zip \
    7zip-zstd \
    7zip.commandline \
    7zip.portable \
    asar7z \
    exfat7z \
    grit7z \
    iso7z \
    modern7z \
    thumbs7z \
    wavpack7z \
    winrar 

EXPOSE 80

ENTRYPOINT ["C:\\ServiceMonitor.exe", "w3svc"]