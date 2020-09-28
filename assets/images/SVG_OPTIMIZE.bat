:: "SVG_OPTIMIZE.bat"                   v1.0.0 | 2019/03/03 | by Tristano Ajmone
:: -----------------------------------------------------------------------------
@ECHO OFF & ECHO [94m
ECHO ===========================================================================[93m
ECHO                           OPTIMIZE ALL SVG FILES                           [94m
ECHO ===========================================================================[93m
ECHO This script will optimize all SVG files in this folder via the SVGO tool.
:: Requires installation of SVGO (Node.js) via NPM:
::
::    https://www.npmjs.com/package/svgo
:: -----------------------------------------------------------------------------
:: Check that SVGO is available:
ECHO.
ECHO  1. Checking that SVGO is available.
CALL SVGO -v 1> NUL 2>&1 || GOTO :ErrReport
ECHO  2. Optimizing all SVG files.[92m
ECHO ---------------------------------------------------------------------------[0m
CALL SVGO -f .\
ECHO [92m---------------------------------------------------------------------------
SET _EXCODE_=0
rem ECHO // Done! //

:EndScript
ECHO.
ECHO [93m// END //[0m
EXIT /B %_EXCODE_%

:ErrReport
ECHO [91m
ECHO ~~~ ERROR!! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO.
ECHO To run this script you need to install SVGO ^(Node^.js^) via NPM:
ECHO.
ECHO    https://www.npmjs.com/package/svgo
ECHO.
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SET _EXCODE_=1
GOTO :EndScript

:: EOF ::
