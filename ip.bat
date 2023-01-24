@echo off
setlocal EnableDelayedExpension

netsh interface ipv4 show config
echo ==================
set /p nom_reseau=Nom du reseau : 
echo ==================
echo IP Statique ou DHCP ? 
echo 1 - Statique
echo 2 - DHCP
echo ==================

:choix
set /p c=1 ou 2 ? 
if %c%==1 goto Statique
if %c%==2 goto DHCP
goto choix 

:Statique
echo off
set /p ip=Adresse IP :
set /p masque=Masque de sous-reseau (defaut=255.255.255.0) : 
set /p passerelle=Passerelle par defaut :
set /p dns1=Serveur DNS prefere (defaut=8.8.4.4):
set /p dns2=Serveur DNS auxiliaire (defaut=8.8.8.8):

if not defined masque (
    set masque="255.255.255.0"
)
if not defined dns1 (
    set dns1="8.8.4.4"
)
if not defined dns2 (
    set dns2="8.8.8.8"
)

netsh interface ipv4 set address name="%nom_reseau%" static "%ip%" "%masque%" "%passerelle%"
netsh interface ipv4 set dnsservers name="%nom_reseau%" static none
netsh interface ipv4 set dnsservers name="%nom_reseau%" static %dns1%
netsh interface ipv4 add dnsservers name="%nom_reseau%" %dns2% index=2
goto PAUSE    

:DHCP
netsh interface ipv4 set address name="%nom_reseau%" source=dhcp
netsh interface ipv4 delete dnsservers name="%nom_reseau%" all
netsh interface ipv4 set dnsservers name="%nom_reseau%" source=dhcp
goto PAUSE

:PAUSE
pause
goto end

:end
