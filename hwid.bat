
@echo off
setlocal enabledelayedexpansion
echo QDI Tool v1.0 by NaCo
echo ====================ϵͳ��Ϣ====================
echo.

for /f "tokens=2 delims==" %%i in ('wmic os get Caption /value') do set osName=%%i
for /f "tokens=2 delims==" %%i in ('wmic os get Version /value') do set osVersion=%%i


for /f "tokens=2 delims==" %%i in ('wmic computersystem get Name /value') do set systemName=%%i
for /f "tokens=2 delims==" %%i in ('wmic cpu get Name /value') do set cpuName=%%i
echo ϵͳ����: %systemName%, ������: %cpuName%
echo Windowsϵͳ�汾: %osName%, �ں˰汾: %osVersion%


echo �û���: %USERNAME%


for /f "tokens=2 delims==" %%i in ('wmic os get InstallDate /value') do set installDate=%%i
set year=%installDate:~0,4%
set month=%installDate:~4,2%
set day=%installDate:~6,2%
set hour=%installDate:~8,2%
set minute=%installDate:~10,2%
set second=%installDate:~12,2%
echo ϵͳ��װ����: %year%-%month%-%day% %hour%:%minute%:%second%

powershell -Command "$BSN = (Get-WmiObject win32_baseboard).SerialNumber ; Write-Host '�������к�: ' -NoNewline; Write-Host $BSN -ForegroundColor Red"
for /f "tokens=2 delims==" %%i in ('wmic computersystem get Manufacturer /value') do set systemManufacturer=%%i
for /f "tokens=2 delims==" %%i in ('wmic computersystem get Model /value') do set systemModel=%%i
echo ϵͳ������: %systemManufacturer%, ϵͳ�ͺ�: %systemModel%

echo.
echo ====================������Ϣ====================
echo.
for /f "tokens=2 delims==" %%i in ('wmic nic where "NetEnabled=true" get Name /value') do (
    set adapterName=%%i
    for /f "tokens=2 delims==" %%j in ('wmic nic where "Name='!adapterName!'" get MACAddress /value') do set adapterMAC=%%j
    for /f "tokens=2 delims==" %%l in ('wmic nicconfig where "Description='!adapterName!'" get DefaultIPGateway /value') do set adapterGateway=%%l
    for /f "tokens=2 delims==" %%k in ('wmic nicconfig where "Description='!adapterName!'" get IPAddress /value') do set IP=%%k
    set "fomartIP=!IP:~1,-2!"
    echo �������ͺ�: !adapterName!
    for %%a in (!fomartIP!) do ( 
        powershell -Command "Write-Host 'IP��ַ: %%~a'"
    )
    powershell -Command "Write-Host 'MAC��ַ: ' -NoNewline; Write-Host '!adapterMAC!' -ForegroundColor Red"
    set "trimmedString=!adapterGateway:~1,-2!"
    for %%a in (!trimmedString!) do ( 
         powershell -Command "Write-Host '����: %%~a'"
    )
)


powershell -Command "try { $ip = Invoke-RestMethod https://myip.ipip.net/s; Write-Host '����IP��ַ��' -NoNewline; Write-Host $ip -ForegroundColor Red } catch { Write-Host '�޷���ȡ����IP��ַ' `n -ForegroundColor Yellow }"


echo ================TPM ������Կ��Ϣ================
echo.
powershell -Command "$tpm = Get-Tpm; Write-Host 'TPM Ʒ��: '$tpm.ManufacturerIdTxt"
powershell -Command "$info = Get-TpmEndorsementKeyInfo -Hash 'sha256'; Write-Host '��Կ��ϣֵ: ' -NoNewline; Write-Host $info.PublicKeyHash -ForegroundColor Red; foreach ($cert in $info.ManufacturerCertificates) { if ($cert.SerialNumber) { Write-Host 'TPM SN: ' -NoNewline; Write-Host $cert.SerialNumber -ForegroundColor Red; Write-Host 'ָ��: '$cert.Thumbprint; break; } }"
echo.
echo ====================Ӳ����Ϣ====================
echo.
powershell -Command "Get-WmiObject Win32_DiskDrive | ForEach-Object { $model = $_.Model; $serialNumber = $_.SerialNumber; Write-Host 'Ӳ���ͺţ�'$model 'Ӳ��SN�룺' -NoNewline; Write-Host $serialNumber -ForegroundColor Red }"
echo.
echo ====================������Ϣ====================
echo.
powershell -Command "Get-WmiObject Win32_PhysicalMemory | ForEach-Object { $manufacturer = $_.Manufacturer; $serialNumber = $_.SerialNumber; Write-Host \"�ڴ���Ʒ�ƣ�$manufacturer �ڴ���ID��$serialNumber\" }"
powershell -Command "Get-WmiObject Win32_VideoController | ForEach-Object { $model = $_.Name; $pnpDeviceID = $_.PNPDeviceID; Write-Host \"�Կ��ͺţ�$model �Կ�ID ��$pnpDeviceID\" }"
echo.

pause

