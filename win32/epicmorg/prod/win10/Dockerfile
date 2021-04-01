FROM mcr.microsoft.com/windows:1809-amd64
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"

ENV chocolateyUseWindowsCompression false

####################################################################################################################################
# https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-docker/manage-windows-dockerfile
####################################################################################################################################

##################################################################
#                   Creating workdir for future
##################################################################
RUN mkdir C:\\EpicMorg
WORKDIR  C:\\EpicMorg

##################################################################
#                   Installing ocolatey.org
##################################################################
RUN powershell -Command \
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
	iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

##################################################################
#                   install vcredist packages
##################################################################
RUN cinst --no-progress  -y  -IgnoreChecksums --ignoredetectedreboot \
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
RUN cinst --no-progress  -y  -IgnoreChecksums --ignoredetectedreboot \
    directx \
    dotnet \
    dotnet-runtime \
    dotnet-sdk \
    powershell-core
 
##################################################################
#                   install base packages
##################################################################
RUN cinst --no-progress  -y  -IgnoreChecksums --ignoredetectedreboot \
    curl \
    far \
    findutils \
    ffmpeg-shared \
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
RUN cinst --no-progress  -y  -IgnoreChecksums --ignoredetectedreboot \
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
 