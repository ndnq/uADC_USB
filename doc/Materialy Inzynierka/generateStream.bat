@echo off
REM Check if a number is provided as an argument
if "%~1"=="" (
    echo Usage: %~0 ^<number^>
    exit /b 1
)

REM Get the provided number
set NUMBER=%~1

REM Run the ffmpeg commands with the provided number
ffmpeg -framerate 5 -i Alignment%%d_%NUMBER%Hz.png -c:v libx264 -pix_fmt yuv420p -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2" Alignment_%NUMBER%Hz.mp4
ffmpeg -i Alignment_%NUMBER%Hz.mp4 Alignment_%NUMBER%Hz.gif