
@echo off
setlocal enabledelayedexpansion

powershell -Command "Write-Host '  ___  __  ____  ____    ____  _  _    __ _   __    ___  __      ' -ForegroundColor Green"
powershell -Command "Write-Host ' / __)/  \(    \(  __)  (  _ \( \/ )  (  ( \ / _\  / __)/  \     ' -ForegroundColor Green"
powershell -Command "Write-Host '( (__(  O )) D ( ) _)    ) _ ( )  /   /    //    \( (__(  O )    ' -ForegroundColor Green"
powershell -Command "Write-Host ' \___)\__/(____/(____)  (____/(__/    \_)__)\_/\_/ \___)\__/     '-ForegroundColor Green"
echo.
powershell -Command "Write-Host ' / )( \/ )( \(  )(    \   /  \ / )( \(  __)(  _ \( \/ )' -ForegroundColor Green"
powershell -Command "Write-Host ' ) __ (\ /\ / )(  ) D (  (  Q )) \/ ( ) _)  )   / )  / ' -ForegroundColor Green"
powershell -Command "Write-Host ' \_)(_/(_/\_)(__)(____/   \__\)\____/(____)(__\_)(__/  '-ForegroundColor Green"
echo.
powershell -Command "Write-Host '系统信息: ' -ForegroundColor DarkYellow"
echo.
for /f "tokens=2 delims==" %%i in ('wmic os get Caption /value') do set osName=%%i
for /f "tokens=2 delims==" %%i in ('wmic os get Version /value') do set osVersion=%%i


for /f "tokens=2 delims==" %%i in ('wmic computersystem get Name /value') do set systemName=%%i
for /f "tokens=2 delims==" %%i in ('wmic cpu get Name /value') do set cpuName=%%i
echo 系统名称: %systemName%, 处理器: %cpuName%
echo Windows系统版本: %osName%, 内核版本: %osVersion%


echo 用户名: %USERNAME%


for /f "tokens=2 delims==" %%i in ('wmic os get InstallDate /value') do set installDate=%%i
set year=%installDate:~0,4%
set month=%installDate:~4,2%
set day=%installDate:~6,2%
set hour=%installDate:~8,2%
set minute=%installDate:~10,2%
set second=%installDate:~12,2%
echo 系统安装日期: %year%-%month%-%day% %hour%:%minute%:%second%

powershell -Command "$BSN = (Get-WmiObject win32_baseboard).SerialNumber ; Write-Host '主板序列号: ' -NoNewline; Write-Host $BSN -ForegroundColor Red"
for /f "tokens=2 delims==" %%i in ('wmic computersystem get Manufacturer /value') do set systemManufacturer=%%i
for /f "tokens=2 delims==" %%i in ('wmic computersystem get Model /value') do set systemModel=%%i
echo 系统制造商: %systemManufacturer%, 系统型号: %systemModel%

echo.
powershell -Command "Write-Host '网卡信息: ' -ForegroundColor DarkYellow"
echo.
for /f "tokens=2 delims==" %%i in ('wmic nic where "NetEnabled=true" get Name /value') do (
    set adapterName=%%i
    for /f "tokens=2 delims==" %%j in ('wmic nic where "Name='!adapterName!'" get MACAddress /value') do set adapterMAC=%%j
    for /f "tokens=2 delims==" %%l in ('wmic nicconfig where "Description='!adapterName!'" get DefaultIPGateway /value') do set adapterGateway=%%l
    for /f "tokens=2 delims==" %%k in ('wmic nicconfig where "Description='!adapterName!'" get IPAddress /value') do set IP=%%k
    set "fomartIP=!IP:~1,-2!"
    echo 适配器型号: !adapterName!
    for %%a in (!fomartIP!) do ( 
        powershell -Command "Write-Host 'IP地址: %%~a'"
    )
    powershell -Command "Write-Host 'MAC地址: ' -NoNewline; Write-Host '!adapterMAC!' -ForegroundColor Red"
    set "trimmedString=!adapterGateway:~1,-2!"
    for %%a in (!trimmedString!) do ( 
         powershell -Command "Write-Host '网关: %%~a'"
    )
)


powershell -Command "try { $ip = Invoke-RestMethod https://myip.ipip.net/s; Write-Host '公网IP地址：' -NoNewline; Write-Host $ip -ForegroundColor Red } catch { Write-Host '无法获取公网IP地址' `n -ForegroundColor Yellow }"

powershell -Command "Write-Host 'TPM 背书密钥信息: ' -ForegroundColor DarkYellow"
echo.
powershell -Command "$tpm = Get-Tpm; Write-Host 'TPM 品牌: '$tpm.ManufacturerIdTxt"
powershell -Command "$info = Get-TpmEndorsementKeyInfo -Hash 'sha256'; Write-Host '公钥哈希值: ' -NoNewline; Write-Host $info.PublicKeyHash -ForegroundColor Red; foreach ($cert in $info.ManufacturerCertificates) { if ($cert.SerialNumber) { Write-Host 'TPM SN: ' -NoNewline; Write-Host $cert.SerialNumber -ForegroundColor Red; Write-Host '指纹: '$cert.Thumbprint; break; } }"
echo.
powershell -Command "Write-Host '硬盘信息: ' -ForegroundColor DarkYellow"
echo.
powershell -Command "Get-WmiObject Win32_DiskDrive | ForEach-Object { $model = $_.Model; $serialNumber = $_.SerialNumber; Write-Host '硬盘型号：'$model '硬盘SN码：' -NoNewline; Write-Host $serialNumber -ForegroundColor Red }"
echo.
powershell -Command "Write-Host '内存信息: ' -ForegroundColor DarkYellow"
echo.
powershell -Command "Get-WmiObject Win32_PhysicalMemory | ForEach-Object { $manufacturer = $_.Manufacturer; $serialNumber = $_.SerialNumber; Write-Host \"内存条品牌：$manufacturer 内存条ID：$serialNumber\" }"
echo.
powershell -Command "Write-Host '显卡信息: ' -ForegroundColor DarkYellow"
echo.
powershell -Command "Get-WmiObject Win32_VideoController | ForEach-Object { $model = $_.Name; $pnpDeviceID = $_.PNPDeviceID; Write-Host \"显卡型号：$model 显卡ID ：$pnpDeviceID\" }"
echo.

pause
