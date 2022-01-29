@echo off
:init
echo.
set adbdl=https://developer.android.com/studio/releases/platform-tools
set aria2dl=https://github.com/aria2/aria2/releases
set ariangdl=https://github.com/mayswind/AriaNg/releases
set ytdldl=https://github.com/ytdl-org/youtube-dl/releases
set ffmpegdl=https://www.ffmpeg.org/download.html
set realesrgandl=https://github.com/xinntao/Real-ESRGAN/releases

:start
echo.
echo 這個安裝程式將會:
echo   -在本安裝程式所在的目錄建立bin目錄及其子目錄(用於放置第三方工具)
echo   -協助您下載相關的專案程式。
pause

:CreateDir
echo.
cd /d %~dp0
title 正在建立bin目錄及其子目錄
mkdir bin
mkdir bin\adb
mkdir bin\dl
mkdir bin\ffmpeg
mkdir bin\RealESRGAN

:DownloadBinary
echo.
echo 由於某些軟體的授權，
echo 您需要自行下載並解壓縮其他軟體專案的可執行檔，
echo 否則這套工具的絕大多數功能將會失效。
echo.
echo 接下來將會開啟以下專案的可執行檔下載頁面:
echo   -adb(fastboot)
echo   -Aria2
echo   -AriaNg
echo   -youtube-dl
echo   -ffmpeg
echo   -Real-ESRGAN
echo ------------------
echo adb:%adbdl%
pause
start %adbdl%

echo aria2:%aria2dl%
pause
start %aria2dl%

echo ariang:%ariangdl%
pause
start %ariangdl%

echo ytdl:%ytdldl%
pause
start %ytdldl%

echo ffmpeg:%ffmpegdl%
pause
start %ffmpegdl%

echo realesrgan:%realesrgandl%
pause
start %realesrgandl%

:UnzipProjects
echo.
echo 下載完成後，請自行依照以下目錄結構解壓縮
echo 解壓縮下載的檔案至bin目錄中對應的目錄。
echo bin
echo ^|--adb        : adb
echo ^|--dl         : aria2,ariang,youtube-dl
echo ^|--ffmpeg     : ffmpeg
echo ^|--RealESRGAN : realesrgan
echo.
pause
