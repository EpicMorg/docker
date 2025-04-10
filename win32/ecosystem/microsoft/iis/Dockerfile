FROM hub.epicm.org/epicmorg/win32:2022-core

####################################################################################################################################
# https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-docker/manage-windows-dockerfile
####################################################################################################################################

##################################################################
#                   Creating workdir for future
##################################################################
RUN mkdir C:\\EpicMorg\\bin

##################################################################
#                   Installing IIS
##################################################################
RUN powershell -Command  Add-WindowsFeature Web-Server ; \
                         Add-WindowsFeature Web-Custom-Logging ; \
                         Add-WindowsFeature Web-Log-Libraries ; \
                         Add-WindowsFeature Web-App-Dev ; \
                         Add-WindowsFeature Web-Net-Ext ; \
                         Add-WindowsFeature Web-Net-Ext45 ; \
                         Add-WindowsFeature Web-AppInit ; \
                         Add-WindowsFeature Web-ASP ; \
                         Add-WindowsFeature Web-Asp-Net ; \
                         Add-WindowsFeature Web-Asp-Net45 ; \
                         Add-WindowsFeature Web-CGI ; \
                         Add-WindowsFeature Web-ISAPI-Ext ; \
                         Add-WindowsFeature Web-ISAPI-Filter ; \
                         Add-WindowsFeature Web-Includes ; \
                         Add-WindowsFeature Web-WebSockets ; \
						 Add-WindowsFeature Web-Mgmt-Tools ; \
						 Add-WindowsFeature Web-Mgmt-Compat ; \
						 Add-WindowsFeature Web-Metabase ; \
						 Add-WindowsFeature Web-Lgcy-Scripting ; \
						 Add-WindowsFeature Web-WMI ; \
						 Add-WindowsFeature Web-Scripting-Tools ; \
						 Add-WindowsFeature Web-Mgmt-Service ; \
                         Invoke-WebRequest -UseBasicParsing \
						     -Uri "https://dotnetbinaries.blob.core.windows.net/servicemonitor/2.0.1.10/ServiceMonitor.exe" \
							 -OutFile "C:\EpicMorg\bin\ServiceMonitor.exe"

RUN powershell -Command  Get-WindowsFeature

EXPOSE 80 443

ENTRYPOINT ["C:\\EpicMorg\\bin\\ServiceMonitor.exe", "w3svc"]