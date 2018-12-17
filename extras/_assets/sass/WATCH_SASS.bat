:: "WATCH_SASS.bat" v1.0.0 (2018/12/16) by Tristano Ajmone
@ECHO OFF
ECHO.
CALL BUILD_SASS.bat
ECHO ===============================
ECHO Build ^& Watch SCSS stylesheets
ECHO ===============================
CALL SCSS --watch %SRC%:%OUT%
EXIT /B

:: EOF ::
