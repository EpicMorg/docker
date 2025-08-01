FROM docker.io/mcr.microsoft.com/windows/servercore:ltsc2022
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
LABEL org.opencontainers.image.vendor="EpicMorg DevTeam, developer@epicm.org"
LABEL org.opencontainers.image.authors="STAM, kasthack, Aleks-Z"
LABEL org.opencontainers.image.source="https://github.com/EpicMorg/docker"
LABEL org.opencontainers.image.url="https://github.com/EpicMorg/docker"
LABEL donate.crypto.TON="EQDvHXRK-K1ZieJhgTD9JZQk7xCnWzRbctYnUkWq1lZq1bUg"
LABEL donate.crypto.ETH="0x26a8443a694f08cdfec966aa6fd72c45068753ec"
LABEL donate.crypto.BTC="bc1querz8ug9asjmsuy6yn4a94a2athgprnu7e5zq2"
LABEL donate.crypto.LTC="ltc1qtwwacq8f0n76fer2y83wxu540hddnmf8cdrlvg"
LABEL donate.crypto.NVC="4SbMynYETyhmKdggu8f38ULU6yQKiJPuo6"
LABEL donate.crypto.DOGE="DHyfE1CZzWtyaQiaMmv6g4KvXVQRUgrYE6"
LABEL donate.crypto.PPC="pQWArPzYoLppNe7ew3QPfto1k1eq66BYUB"
LABEL donate.crypto.RVN="R9t2LKeLhDSZBKNgUzSDZAossA3UqNvbV3"
LABEL donate.crypto.ZEC="t1KRMMmwMSZth8vJcd2ZHtPEFKTQ74yVixE"
LABEL donate.crypto.XMR="884PqZ1gDjWW7fKxtbaeRoBeSh9EGZbkqUyLriWmuKbwLZrAJdYUs4wQxoVfEJoW7LBhdQMP9cFhZQpJr6xvg7esHLdCbb1"

####################################################################################################################################
# https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-docker/manage-windows-dockerfile
####################################################################################################################################

ENV chocolateyUseWindowsCompression false
# Opt out of the telemetry feature
ENV DOTNET_CLI_TELEMETRY_OPTOUT=true
# Disable first time experience
ENV DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true
# Configure Kestrel web server to bind to port 80 when present
#ENV ASPNETCORE_URLS=/
# Enable detection of running in a container
ENV DOTNET_RUNNING_IN_CONTAINER=true
# Enable correct mode for dotnet watch (only mode supported in a container)
ENV DOTNET_USE_POLLING_FILE_WATCHER=true
# Skip extraction of XML docs - generally not useful within an image/container - helps perfomance
ENV NUGET_XMLDOC_MODE=skip
# PowerShell telemetry for docker image usage
ENV POWERSHELL_DISTRIBUTION_CHANNEL=docker-windows
# Enable detection of running in a container
ENV DOTNET_RUNNING_IN_CONTAINER=true
ENV COMPLUS_RUNNING_IN_CONTAINER=1
ENV COMPLUS_NGenProtectedProcess_FeatureEnabled=0

##################################################################

ENV EMG_WORKDIR=C:\\EpicMorg
ENV EMG_VOLDIR=C:\\EpicMorg\\mount

##################################################################
#                   Creating workdir for future
##################################################################
RUN mkdir C:\\EpicMorg
WORKDIR  C:\\EpicMorg
VOLUME  C:\\EpicMorg\\mount

##################################################################
#                   Installing ocolatey.org
##################################################################
RUN powershell -Command \
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

##################################################################
#                   install vcredist packages
##################################################################
RUN choco install -y --ignore-checksums --allow-empty-checksums --ignoredetectedreboot --ignore-package-exit-codes \
    visualfsharptools \
    vcredist2005 \
    vcredist2008 \
    vcredist2010 \
    vcredist2012 \
    vcredist2013 \
    vcredist2013 \
    vcredist2015 \
    vcredist2017 \
    vcredist-all \
    vcredist140

##################################################################
#                   install dotnet packages
##################################################################
RUN choco install -y --ignore-checksums --allow-empty-checksums --ignoredetectedreboot --ignore-package-exit-codes \
    dotnetfx \
    netfx-4.8-devpack \
    dotnet \
    dotnet-runtime \
    dotnet-desktopruntime \
    dotnet-sdk \
    powershell-core

# Apply patch to provide support for container limits
RUN curl -fSLo patch.msu https://download.microsoft.com/download/1/d/1/1d162522-821a-41c6-ba7d-74ff37b0e6c6/Windows10.0-KB9008395-x64-NDP48.msu && \
    mkdir patch && \
    expand patch.msu patch -F:* && \
    del /F /Q patch.msu && \
    dism /Online /Add-Package /PackagePath:C:\EpicMorg\patch\windows10.0-kb9008395-x64-ndp48.cab && \
    rmdir /S /Q patch
    # && \ 
# Ngen top of assembly graph to optimize a set of frequently used assemblies
#    %windir%\Microsoft.NET\Framework64\v4.0.30319\ngen install /verbose "Microsoft.PowerShell.Utility.Activities, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"  && \ 
# To optimize 32-bit assemblies, uncomment the next line
#     %windir%\Microsoft.NET\Framework\v4.0.30319\ngen /verbose install "Microsoft.PowerShell.Utility.Activities, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"  && \ 

##################################################################
#                   install base packages
##################################################################
RUN choco install -y --ignore-checksums --allow-empty-checksums --ignoredetectedreboot --ignore-package-exit-codes \
    psexec \
    curl \
    far \
    findutils \
    git \
    git.install \
    git-lfs \
    git-lfs.install \
    make \
    mc \
    nano \
    openssl \
    sed \
    steamcmd \
    sudo \
    tartool \
    unzip \
    wget

##################################################################
#                   install archive packages
##################################################################
RUN choco install -y --ignore-checksums --allow-empty-checksums --ignoredetectedreboot --ignore-package-exit-codes \
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

