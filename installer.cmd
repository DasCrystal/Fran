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
echo �o�Ӧw�˵{���N�|:
echo   -�b���w�˵{���Ҧb���ؿ��إ�bin�ؿ��Ψ�l�ؿ�(�Ω��m�ĤT��u��)
echo   -��U�z�U���������M�׵{���C
pause

:CreateDir
echo.
cd /d %~dp0
title ���b�إ�bin�ؿ��Ψ�l�ؿ�
mkdir bin
mkdir bin\adb
mkdir bin\dl
mkdir bin\ffmpeg
mkdir bin\RealESRGAN

:DownloadBinary
echo.
echo �ѩ�Y�ǳn�骺���v�A
echo �z�ݭn�ۦ�U���ø����Y��L�n��M�ת��i�����ɡA
echo �_�h�o�M�u�㪺���j�h�ƥ\��N�|���ġC
echo.
echo ���U�ӱN�|�}�ҥH�U�M�ת��i�����ɤU������:
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
echo �U��������A�Цۦ�̷ӥH�U�ؿ����c�����Y
echo �����Y�U�����ɮצ�bin�ؿ����������ؿ��C
echo bin
echo ^|--adb        : adb
echo ^|--dl         : aria2,ariang,youtube-dl
echo ^|--ffmpeg     : ffmpeg
echo ^|--RealESRGAN : realesrgan
echo.
pause
