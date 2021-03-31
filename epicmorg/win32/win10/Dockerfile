FROM mcr.microsoft.com/windows:20H2
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"

ENV chocolateyUseWindowsCompression false

##################################################################
#                   Installing ocolatey.org
##################################################################
RUN powershell -Command \
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
	iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

##################################################################
#                   install base packages
##################################################################
RUN cinst --no-progress  -y  -IgnoreChecksums \
    7zip-zstd \
    7zip.commandline \
    7zip.portable \
    asar7z \
    curl \
    directx \
    dotnetfx \
    exfat7z \
    far \
    git \
    grit7z \
    iso7z \
    mc \
    modern7z \
    powershell \
    powershell-core \
    steamcmd \
    sudo \
    tartool \
    thumbs7z \
    vcredist-all \
    vcredist140 \
    vcredist2005 \
    vcredist2008 \
    vcredist2010 \
    vcredist2012 \
    vcredist2013 \
    vcredist2013 \
    vcredist2015 \
    unrar \
    unzip \
    wavpack7z \
    winrar \
    wget
