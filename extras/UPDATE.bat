@ECHO OFF & :: "UPDATE.bat" v1.0.0
ECHO ===================================
ECHO UPDATE CONTENTS OF "StdLib/" FOLDER
ECHO ===================================

:: ----------------------------------------
:: 1. COMPILE ALL ADVENTURES IN THIS FOLDER
:: ----------------------------------------
FOR %%i IN (*.alan) DO CALL :CompileAdventure %%i

EXIT /B

:: /// FUNCTIONS ///

:CompileAdventure
ECHO COMPILE: %1
CALL alan.exe %1  > nul 2>&1 ^
  || (
    ECHO ^*^* COMPILATION FAILED ^*^*
  )
EXIT /B
