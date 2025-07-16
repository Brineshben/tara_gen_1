@echo off
setlocal EnableDelayedExpansion

REM Read current version line
for /f "tokens=1,2 delims=:" %%A in ('findstr "version:" pubspec.yaml') do (
    set "version_line=%%B"
)

REM Remove spaces
set "version_line=%version_line: =%"
set "old_version_line=version:%version_line%"

REM Split version_name and build_number
for /f "tokens=1,2 delims=+" %%A in ("%version_line%") do (
    set "version_name=%%A"
    set "build_number=%%B"
)

REM Split version_name into major.minor.patch
for /f "tokens=1,2,3 delims=." %%A in ("%version_name%") do (
    set "major=%%A"
    set "minor=%%B"
    set "patch=%%C"
)

echo.
echo What do you want to increase?
echo [1] Major version (e.g., 1.0.0 → 2.0.0)
echo [2] Minor version (e.g., 1.0.0 → 1.1.0)
echo [3] Patch version (e.g., 1.0.0 → 1.0.1)
set /p choice=Enter 1, 2, or 3:

if "%choice%"=="1" (
    set /a major=major + 1
    set minor=0
    set patch=0
)
if "%choice%"=="2" (
    set /a minor=minor + 1
    set patch=0
)
if "%choice%"=="3" (
    set /a patch=patch + 1
)

REM Always increase build number
set /a new_build=build_number + 1

REM Create new version string
set "new_version_name=%major%.%minor%.%patch%"
set "new_version_line=version: %new_version_name%+%new_build%"

REM Replace version line in pubspec.yaml
(for /f "delims=" %%A in (pubspec.yaml) do (
    echo %%A | findstr /c:"version:" >nul
    if errorlevel 1 (
        echo %%A
    ) else (
        echo %new_version_line%
    )
)) > temp.yaml

move /Y temp.yaml pubspec.yaml >nul

echo.
echo Old Version: %old_version_line%
echo New Version: %new_version_line%
echo.

echo ✅ Updated to: %new_version_line%
echo 🚀 Building APK...

flutter build apk

pause
