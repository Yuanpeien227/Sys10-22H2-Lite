@echo off
setlocal enabledelayedexpansion
title Windows10 22H2 Lite
color a
chcp 65001 >nul

::==============提权区域==============
fltmc >nul 2>&1
if %errorlevel% neq 0 (
    echo 正在请求管理员权限...
    powershell -Command "Start-Process -FilePath '%~s0' -Verb RunAs"
    exit /b
)

CD /D "%~dp0"
::===================================

::==============变量区==============
set "WimPath=%~dp0image\install.wim"
set "MountDir=%~dp0Temp"
set "AutoDIR=%~dp0autounattend.xml"
::===================================

::==============代码区==============
echo 正在创建挂载目录...
if not exist "%MountDir%" md "%MountDir%"

echo 正在挂载镜像...
dism /Mount-Image /ImageFile:"%WimPath%" /Index:6 /MountDir:"%MountDir%"

:: -------- 注入无人值守文件（复制到 Panther 目录）--------
if exist "%AutoDIR%" (
    echo 正在注入无人值守文件到镜像...
    if not exist "%MountDir%\Windows\Panther" md "%MountDir%\Windows\Panther"
    copy /y "%AutoDIR%" "%MountDir%\Windows\Panther\unattend.xml"
    if errorlevel 1 (
        echo 警告：复制无人值守文件失败，请检查路径和权限。
    ) else (
        echo 无人值守文件已成功注入到 Windows\Panther\unattend.xml
    )
) else (
    echo 警告：未找到无人值守文件 %AutoDIR%，跳过。
)

:: ========== 第一部分：删除系统包 (Packages) ==========
echo [1/5] 正在删除系统包...

dism /Image:"%MountDir%" /Remove-Package /PackageName:"Microsoft-Windows-MediaPlayer-Package~31bf3856ad364e35~amd64~~10.0.19041.2965" 2>nul
dism /Image:"%MountDir%" /Remove-Package /PackageName:"Microsoft-Windows-InternetExplorer-Optional-Package~31bf3856ad364e35~amd64~~11.0.19041.1566" 2>nul
dism /Image:"%MountDir%" /Remove-Package /PackageName:"Microsoft-Windows-QuickAssist-Package~31bf3856ad364e35~amd64~~10.0.19041.2913" 2>nul
dism /Image:"%MountDir%" /Remove-Package /PackageName:"Microsoft-Windows-TabletPCMath-Package~31bf3856ad364e35~amd64~~10.0.19041.2193" 2>nul
dism /Image:"%MountDir%" /Remove-Package /PackageName:"Microsoft-Windows-UserExperience-Desktop-Package~31bf3856ad364e35~amd64~~10.0.19041.2913" 2>nul
dism /Image:"%MountDir%" /Remove-Package /PackageName:"Microsoft-OneCore-ApplicationModel-Sync-Desktop-FOD-Package~31bf3856ad364e35~amd64~~10.0.19041.1949" 2>nul
dism /Image:"%MountDir%" /Remove-Package /PackageName:"OpenSSH-Client-Package~31bf3856ad364e35~amd64~~10.0.19041.964" 2>nul

:: ========== 第二部分：删除语言包 ==========
echo [2/5] 正在删除语言包...

dism /Image:"%MountDir%" /Remove-Package /PackageName:"Microsoft-Windows-LanguageFeatures-Handwriting-zh-cn-Package~31bf3856ad364e35~amd64~~10.0.19041.746" 2>nul
dism /Image:"%MountDir%" /Remove-Package /PackageName:"Microsoft-Windows-LanguageFeatures-OCR-zh-cn-Package~31bf3856ad364e35~amd64~~10.0.19041.1" 2>nul
dism /Image:"%MountDir%" /Remove-Package /PackageName:"Microsoft-Windows-LanguageFeatures-Speech-zh-cn-Package~31bf3856ad364e35~amd64~~10.0.19041.1" 2>nul
dism /Image:"%MountDir%" /Remove-Package /PackageName:"Microsoft-Windows-LanguageFeatures-TextToSpeech-zh-cn-Package~31bf3856ad364e35~amd64~~10.0.19041.1" 2>nul

:: ========== 第三部分：删除应用本地化资源 ==========
echo [3/5] 正在删除应用本地化资源...

dism /Image:"%MountDir%" /Remove-Package /PackageName:"Microsoft-Windows-Printing-PMCPPC-FoD-Package~31bf3856ad364e35~amd64~~10.0.19041.1806" 2>nul
dism /Image:"%MountDir%" /Remove-Package /PackageName:"Microsoft-Windows-Printing-WFS-FoD-Package~31bf3856ad364e35~amd64~~10.0.19041.2604" 2>nul

:: ========== 第四部分：删除预配应用包 (Appx) ==========
echo [4/5] 正在删除预配应用包...

DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.BingWeather_4.25.20211.0_neutral_~_8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.GetHelp_10.1706.13331.0_neutral_~_8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.Getstarted_8.2.22942.0_neutral_~_8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.Microsoft3DViewer_6.1908.2042.0_neutral_~_8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.MicrosoftOfficeHub_18.1903.1152.0_neutral_~_8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.MicrosoftSolitaireCollection_4.4.8204.0_neutral_~_8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.MicrosoftStickyNotes_3.6.73.0_neutral_~_8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.MSPaint_2019.729.2301.0_neutral_~_8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.Office.OneNote_16001.12026.20112.0_neutral_~_8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.People_2019.305.632.0_neutral_~_8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.SkypeApp_14.53.77.0_neutral_~_kzf8qxf38zg5c 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.Wallet_2.4.18324.0_neutral_~_8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsAlarms_2019.807.41.0_neutral_~_8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsCamera_2018.826.98.0_neutral_~_8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsFeedbackHub_2019.1111.2029.0_neutral_~_8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsMaps_2019.716.2316.0_neutral_~_8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsSoundRecorder_2019.716.2313.0_neutral_~_8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.StorePurchaseApp_11811.1001.1813.0_neutral_~_8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsStore_11910.1002.513.0_neutral_~_8wekyb3d8bbwe 2>nul

:: --- Xbox 相关 ---
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.XboxApp_48.49.31001.0_neutral_~_8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.Xbox.TCUI_1.23.28002.0_neutral_~_8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.XboxIdentityProvider_12.50.6001.0_neutral_~_8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.XboxSpeechToTextOverlay_1.17.29001.0_neutral_~_8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.XboxGameOverlay_1.46.11001.0_neutral_~_8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.XboxGamingOverlay_2.34.28001.0_neutral_~_8wekyb3d8bbwe 2>nul

:: --- 媒体扩展 ---
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.HEIFImageExtension_1.0.22742.0_x64__8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.VP9VideoExtensions_1.0.22681.0_x64__8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WebMediaExtensions_1.0.20875.0_neutral_~_8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WebpImageExtension_1.0.22753.0_x64__8wekyb3d8bbwe 2>nul

:: --- 其他应用 ---
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.YourPhone_2019.430.2026.0_neutral_~_8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.ZuneMusic_2019.19071.19011.0_neutral_~_8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.ZuneVideo_2019.19071.19011.0_neutral_~_8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.windowscommunicationsapps_16005.11629.20316.0_neutral_~_8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsCalculator_2020.1906.55.0_neutral_~_8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.Windows.Photos_2019.19071.12548.0_neutral_~_8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.ScreenSketch_2019.904.1644.0_neutral_~_8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.MixedReality.Portal_2000.19081.1301.0_neutral_~_8wekyb3d8bbwe 2>nul
DISM /Image:"%MountDir%" /Remove-ProvisionedAppxPackage /PackageName:Microsoft.549981C3F5F10_1.1911.21713.0_neutral_~_8wekyb3d8bbwe 2>nul

:: ========== 第五部分：禁用并删除 Windows 功能 ==========
echo [5/5] 正在禁用并删除 Windows 功能...

DISM /Image:"%MountDir%" /Disable-Feature /FeatureName:TFTP /Remove 2>nul
DISM /Image:"%MountDir%" /Disable-Feature /FeatureName:TelnetClient /Remove 2>nul
DISM /Image:"%MountDir%" /Disable-Feature /FeatureName:SimpleTCP /Remove 2>nul
DISM /Image:"%MountDir%" /Disable-Feature /FeatureName:SMB1Protocol /Remove 2>nul
DISM /Image:"%MountDir%" /Disable-Feature /FeatureName:LegacyComponents /Remove 2>nul
DISM /Image:"%MountDir%" /Disable-Feature /FeatureName:DirectPlay /Remove 2>nul
DISM /Image:"%MountDir%" /Disable-Feature /FeatureName:Microsoft-Hyper-V-All /Remove 2>nul
DISM /Image:"%MountDir%" /Disable-Feature /FeatureName:Containers /Remove 2>nul
DISM /Image:"%MountDir%" /Disable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux /Remove 2>nul
DISM /Image:"%MountDir%" /Disable-Feature /FeatureName:HypervisorPlatform /Remove 2>nul
DISM /Image:"%MountDir%" /Disable-Feature /FeatureName:VirtualMachinePlatform /Remove 2>nul
DISM /Image:"%MountDir%" /Disable-Feature /FeatureName:Client-ProjFS /Remove 2>nul
DISM /Image:"%MountDir%" /Disable-Feature /FeatureName:WorkFolders-Client /Remove 2>nul
DISM /Image:"%MountDir%" /Disable-Feature /FeatureName:ServicesForNFS-ClientOnly /Remove 2>nul
DISM /Image:"%MountDir%" /Disable-Feature /FeatureName:MultiPoint-Connector /Remove 2>nul
DISM /Image:"%MountDir%" /Disable-Feature /FeatureName:DirectoryServices-ADAM-Client /Remove 2>nul
DISM /Image:"%MountDir%" /Disable-Feature /FeatureName:Windows-Identity-Foundation /Remove 2>nul
DISM /Image:"%MountDir%" /Disable-Feature /FeatureName:Printing-Foundation-LPDPrintService /Remove 2>nul
DISM /Image:"%MountDir%" /Disable-Feature /FeatureName:Printing-Foundation-LPRPortMonitor /Remove 2>nul
DISM /Image:"%MountDir%" /Disable-Feature /FeatureName:Client-DeviceLockdown /Remove 2>nul
DISM /Image:"%MountDir%" /Disable-Feature /FeatureName:DataCenterBridging /Remove 2>nul
DISM /Image:"%MountDir%" /Disable-Feature /FeatureName:SmbDirect /Remove 2>nul
DISM /Image:"%MountDir%" /Disable-Feature /FeatureName:AppServerClient /Remove 2>nul
DISM /Image:"%MountDir%" /Disable-Feature /FeatureName:TIFFIFilter /Remove 2>nul
DISM /Image:"%MountDir%" /Disable-Feature /FeatureName:IIS-WebServerRole /Remove 2>nul
DISM /Image:"%MountDir%" /Disable-Feature /FeatureName:MSMQ-Container /Remove 2>nul

:: ========== 第六部分：清理 WinSxS 并卸载 ==========
echo 正在清理 WinSxS 组件存储...
Dism /Image:"%MountDir%" /Cleanup-Image /StartComponentCleanup
:: 注意：下面的 /ResetBase 会彻底清除旧版组件，使更新无法卸载，谨慎使用！
:: Dism /Image:"%MountDir%" /Cleanup-Image /StartComponentCleanup /ResetBase

echo 正在提交更改并卸载镜像...
DISM /Unmount-Image /MountDir:"%MountDir%" /Commit

echo 正在删除挂载目录...
if exist "%MountDir%" rmdir /s /q "%MountDir%"

::=======================文件转换区==========================
echo.
echo;接下来会将 WIM 镜像转换为 ESD 镜像。
echo.
pause

if exist "%~dp0image\install.esd" del /f /q "%~dp0image\install.esd"
Dism /Export-Image /SourceImageFile:"%WimPath%" /SourceIndex:6 /DestinationImageFile:"%~dp0image\install.esd" /Compress:recovery

if errorlevel 1 (
    echo 导出失败，请检查日志。
    pause
    exit /b 1
)

echo.
echo;========================================
echo;所有操作已完成！
echo;精简后的 ESD 文件: %~dp0image\install.esd
echo;========================================
pause