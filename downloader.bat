echo off
goto BEGIN
:BEGIN
set filePath=%cd%
set yt-dlpPath=%~dp0
pushd %yt-dlpPath%
echo Current filepath: %filePath%
echo yt-dlp filepath: %yt-dlpPath%
set /p VA="Video or audio (or audio playlist) or both? (v/a/ap/va): "
set /P link="Give link to convert "
if %VA%==v goto V
if %VA%==a goto A
if %VA%==va goto VAA
if %VA%==ap goto AP
:V
yt-dlp -P "%filePath%" --youtube-skip-dash-manifest -i -f "bestvideo[ext=mp4][width<=1920][protocol=https]" --yes-playlist "%link%"
goto end
:A
yt-dlp -P "%filePath%" -i -f "ba[ext=m4a]/ba[ext=mp3]" --yes-playlist "%link%"
forfiles /p "%filePath%" /m "*.m4a" /C "cmd /c cd %yt-dlpPath% && ffmpeg -i @path -acodec libmp3lame -aq 2 @path.mp3"
popd
Rem for %%a in (*.m4a) do set "name=%%a"
Rem echo Deleting unnecessary m4a files...
Rem del "%filePath%\%name%" /f /q
goto end
:AP
set /p length="Give Playlist lenght: "
set /a realLenght=length
goto :AC
:AC
if %realLenght%==0 (goto :end) else (yt-dlp -P "%filePath%" -i -f "bestaudio[ext=m4a]" --playlist-items "%realLenght%" "%link%")
forfiles /p "%filePath%" /m "*.m4a" /C "cmd /c cd %yt-dlpPath% && ffmpeg -i @path -acodec libmp3lame -aq 2 @path.mp3"
popd
for %%a in (*.m4a) do set "name=%%a"
echo Deleting unnecessary m4a files...
del "%filePath%\%name%" /f /q
set /a realLenght=realLenght-1
pushd %yt-dlpPath%
goto :AC
:VAA
yt-dlp -P "%filePath%" -i -f "bestvideo[ext=mp4][width<=1920][protocol=https]+bestaudio[ext=m4a]" --yes-playlist "%link%"
popd
goto end
:end
pause
goto BEGIN