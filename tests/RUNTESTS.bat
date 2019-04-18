:: "RUNTESTS.bat" v3.1.0 (2019/04/18) | by Tristano Ajmone
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                                                                            ::
::                      ALAN STANDARD LIBRARY TEST SUITE                      ::
::                                                                            ::
::                             by Tristano Ajmone                             ::
::                                                                            ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@ECHO OFF & CLS
:: -----------------------------------------------------------------------------
:: This script handles two different type of tests folders:
:: 
::   (a) Single Adventure    -> Multiple Tests.
::   (b) Multiple Adventures -> One/More Tests per Adventure.
:: 
:: It's possible to run tests of type (a) on an unlimited number of folders, but
:: tests of type (b) can be run on a single folder only.
:: =============================================================================
::                             Setup Tests Folders                              
:: =============================================================================
:: Single Adventure -> Multiple Tests
:: -----------------------------------------------------------------------------
:: Don't include the ".alan" extension in the adventure filenames!
SET ADV_SINGLE[1]DIR=house
SET ADV_SINGLE[1]ADV=house
SET ADV_SINGLE[2]DIR=clothing
SET ADV_SINGLE[2]ADV=ega
:: -----------------------------------------------------------------------------
:: Multiple Adventures -> One/More Tests per Adventure
:: -----------------------------------------------------------------------------
SET ADV_MULTIPLE_DIR=misc
:: =============================================================================
::                              Preliminary Setup                               
:: =============================================================================
SET "INITIAL_PATH=%CD%" &:: Store current path
:: =================
:: Environment Setup
:: =================
SETLOCAL EnableDelayedExpansion

:: Set code page to UTF-8 for handling special chars in commands scripts:
CHCP 65001 > nul 2>&1

CALL :DefineANSICodes   &:: Defines some ANSI codes & colors variables
:: =================================
:: Print Title Banner and Intro Text
:: =================================
CALL :PrintBanner    &:: Prints the title banner
ECHO.
:: =======================
:: Define Script Variables
:: =======================
SET   "_COMPILE_OPTS_=-import ..\..\StdLib\ -debug"
SET /A _ERR_=0       &:: (counter)  Errors -> Total (for Exit Code)
SET /A _ADV_COM_=0   &:: (counter)  Adventures -> Compiled
SET /A _ADV_ERR_=0   &:: (counter)  Adventures -> Compiler Errors
SET /A _ADV_EXE_=0   &:: (counter)  Adventures -> Tested
SET /A _ADV_TOT_=0   &:: (counter)  Adventures -> Total
SET /A _CNT_EXE_=0   &:: (counter)  Processing operations -> Executed
SET /A _CNT_TOT_=0   &:: (counter)  Processing operations -> Total
SET /A _STP_EXE_=0   &:: (counter)  Steps -> Executed
SET /A _STP_TOT_=5   &:: (counter)  Steps -> Total
SET /A _TST_EXE_=0   &:: (counter)  Commands script -> Executed
SET /A _TST_TOT_=0   &:: (counter)  Commands script -> Total
:: =============================================================================
:: step 1                    Preliminary Calculations                           
:: =============================================================================
CALL :StepTitle "Preliminary Calculations"
:: ===========================================
:: Calculate Total Number of Source Adventures
:: ===========================================
ECHO The following adventures will be compiled:%_GRAY_%
:: Iterate Folders of Single Adventure -> Multiple Tests:
SET /A TMPC=1
:LoopCountSources
IF "!ADV_SINGLE[%TMPC%]DIR!" == "" GOTO :EndLoopCountSources
CALL :CountSources !ADV_SINGLE[%TMPC%]DIR!
SET /A "TMPC+=1"
GOTO :LoopCountSources
:EndLoopCountSources
:: Folder of Multiple Adventures -> One/More Tests per Adventure:
CALL :CountSources %ADV_MULTIPLE_DIR%
:: Aggiungi il numero delle avventure alle operazioni totali da eseguire:
SET /A _CNT_TOT_=!_CNT_TOT_! +!_ADV_TOT_!
ECHO.
:: ===============================
:: Calculate Total Number of Tests
:: ===============================
ECHO %_WHITE_%The following commands scripts will be executed:%_GRAY_%
:: Iterate Folders of Single Adventure -> Multiple Tests:
SET /A TMPC=1
:LoopCountScripts
IF "!ADV_SINGLE[%TMPC%]DIR!" == "" GOTO :EndLoopCountScripts
CALL :CountScripts !ADV_SINGLE[%TMPC%]DIR!
SET /A "TMPC+=1"
GOTO :LoopCountScripts
:EndLoopCountScripts
:: Folder of Multiple Adventures -> One/More Tests per Adventure:
CALL :CountScripts %ADV_MULTIPLE_DIR%
:: Add number of tests to the total number of pending operations:
SET /A _CNT_TOT_=!_CNT_TOT_! +!_TST_TOT_!
:: =============================================================================
:: step 2           Delete Old Files Generated by This Script                   
:: =============================================================================
CALL :StepTitle "Delete Old Files"
ECHO Eliminating old files generated by this script:
:: Iterate Folders of Single Adventure -> Multiple Tests:
SET /A TMPC=1
:LoopClean
IF "!ADV_SINGLE[%TMPC%]DIR!" == "" GOTO :EndLoopClean
CALL :CleanupFolder !ADV_SINGLE[%TMPC%]DIR!
SET /A "TMPC+=1"
GOTO :LoopClean
:EndLoopClean
:: Folder of Multiple Adventures -> One/More Tests per Adventure:
CALL :CleanupFolder %ADV_MULTIPLE_DIR%
:: =============================================================================
:: step 3                   Compile Source Adventures                           
:: =============================================================================
CALL :StepTitle "Compile Source Adventures"
SET /A _CNT_TMP_=0   &:: Temporary counter for compile operations
SET /A _ERR_TMP_=0   &:: Temporary counter for compile errors
:: Iterate Folders of Single Adventure -> Multiple Tests:
SET /A TMPC=1
:LoopCompile
IF "!ADV_SINGLE[%TMPC%]DIR!" == "" GOTO :EndLoopCompile
CALL :CompileFolder !ADV_SINGLE[%TMPC%]DIR!
SET /A "TMPC+=1"
GOTO :LoopCompile
:EndLoopCompile
:: Folder of Multiple Adventures -> One/More Tests per Adventure:
CALL :CompileFolder %ADV_MULTIPLE_DIR%
IF %_ADV_ERR_% GEQ  1 (
    CALL :ErrorFrame
    ECHO COMPILE ERRORS: %_ADV_ERR_%
    ECHO It won't be possible to execute tests until the problem is solved.
    ECHO %_WHITE_%Aborting script execution...
    GOTO :FinalReport
)
:: =============================================================================
:: step 4                       Execute All Tests                               
:: =============================================================================
CALL :StepTitle "Execute All Tests"
CALL :TestSingleAdv
CALL :TestMultiAdv
:: =============================================================================
:: step 5                       Print Final Report                              
:: =============================================================================
:FinalReport

CALL :StepTitle "FINAL REPORT"
ECHO %_WHITE_%Tests execution completed.
ECHO.
:: --------------------------------------------------------
:: Report total number of adventures successfully compiled:
:: --------------------------------------------------------
SET TEMP_COL=%_GREEN_%
IF %_ADV_COM_% NEQ %_ADV_TOT_% (
    SET TEMP_COL=%_RED_%
)
ECHO %TEMP_COL%ADVENTURES COMPILED:   %_ADV_COM_%/%_ADV_TOT_%
:: -----------------------------------------
:: Report total number of tested adventures:
:: -----------------------------------------
SET TEMP_COL=%_GREEN_%
IF %_ADV_EXE_% NEQ %_ADV_TOT_% (
    SET TEMP_COL=%_RED_%
)
ECHO %TEMP_COL%ADVENTURES TESTED:     %_ADV_EXE_%/%_ADV_TOT_%
:: -----------------------------------------------------------
:: Report total number of commands scripts found and executed:
:: -----------------------------------------------------------
SET TEMP_COL=%_GREEN_%
IF %_TST_EXE_% NEQ %_TST_TOT_% (
    SET TEMP_COL=%_RED_%
)
ECHO %TEMP_COL%TEST SCRIPTS EXECUTED: %_TST_EXE_%/%_TST_TOT_%
:: ------------------------------------------
:: Report total number of errors encountered:
:: ------------------------------------------
IF %_ERR_% EQU 0 (
    ECHO %_GREEN_%ERRORS: NONE
    ) ELSE (
    ECHO %_RED_%ERRORS: %_ERR_%
)
:: =============================================================================
::                        Clean Up and Terminate Script                         
:: =============================================================================
:TerminateScript

CD %INITIAL_PATH% &:: Restore original path
:: Reset ANSI terminal codes and colors:
ECHO %_RESET_COLORS_%
:: Reset variables (required due to CMD /K further on):
CALL :DestroyANSICodes

SET _COMPILE_OPTS_=
SET ADV_MULTIPLE_DIR=
SET ADV_SINGLE=
SET ADV_SINGLE_DIR=
SET INITIAL_PATH=

SET _ADV_COM_=
SET _ADV_ERR_=
SET _ADV_EXE_=
SET _ADV_TOT_=
SET _CNT_EXE_=
SET _CNT_TOT_=
SET _STP_EXE_=
SET _STP_TOT_=
SET _TST_EXE_=
SET _TST_TOT_=

:: Temporary vars:
SET _CNT_TMP_=
SET _ERR_TMP_=
SET _STR_ADV_=
SET _STR_CNT_=
SET ADV_BIN=
SET TEMP_COL=

ECHO // THE END //
:: Ensure that CMD remains open if the script was launched via File Explorer:
ECHO "%cmdcmdline%" | FINDSTR /IC:"%windir%" >nul && (
    CMD /K
)
EXIT /B %_ERR_%

:: *****************************************************************************
:: *                                                                           *
:: *                             SETUP FUNCTIONS                               *
:: *                                                                           *
:: *****************************************************************************

:: =============================================================================
:: func                      Count Source Adventures                            
:: =============================================================================
:: PARAMETERS: folder name.
:: -----------------------------------------------------------------------------
:CountSources

FOR %%i IN (%~1\*.alan) DO (
    SET /A _ADV_TOT_=!_ADV_TOT_! +1
    ECHO   !_ADV_TOT_!. %_YELLOW_%%%i%_GRAY_%
)
EXIT /B
:: =============================================================================
:: func                       Count Commands-Scripts                            
:: =============================================================================
:: PARAMETERS: folder name.
:: -----------------------------------------------------------------------------
:CountScripts

FOR %%i IN (%~1\*.a3sol) DO (
    SET /A _TST_TOT_=!_TST_TOT_! +1
    ECHO   !_TST_TOT_!. %_YELLOW_%%%i%_GRAY_%
)
EXIT /B
:: =============================================================================
:: func             Cleanup Folder from Previous Output Files                   
:: =============================================================================
:: PARAMETERS: folder name.
:: -----------------------------------------------------------------------------
:CleanupFolder

CALL :DeleteFile %~1\*.a3c
CALL :DeleteFile %~1\*.a3log
CALL :DeleteFile %~1\*.ifid
CALL :DeleteFile %~1\*.log
EXIT /B
:: =============================================================================
:: func                            Delete File                                  
:: =============================================================================
:: PARAMETERS: the file or file-pattern to delete.
:: -----------------------------------------------------------------------------
:DeleteFile

ECHO %_GRAY_%  -%_CYAN_% %1%_GRAY_%
DEL %1 2> nul
EXIT /B
:: *****************************************************************************
:: *                                                                           *
:: *                      ADVENTURE COMPILING FUNCTIONS                        *
:: *                                                                           *
:: *****************************************************************************

:: =============================================================================
:: func                  Compile Every Source in a Folder                       
:: =============================================================================
:: PARAMETERS: folder name.
:: -----------------------------------------------------------------------------
:CompileFolder

PUSHD %~1
FOR %%i IN (*.alan) DO (
    SET /A _CNT_TMP_=!_CNT_TMP_! +1
    SET "_STR_CNT_=!_CNT_TMP_!/%_ADV_TOT_%"
    SET "_STR_ADV_=^"%_MAGENTA_%%~1\%_YELLOW_%%%i%_BLUE_%^""
    CALL :OperationTitle "COMPILE !_STR_CNT_! !_STR_ADV_!"
    CALL :CompileAdv "%%i"
)
POPD
EXIT /B
:: =============================================================================
:: func                      Compile Source Adventure                           
:: =============================================================================
:: PARAMETERS: the ".alan" source to compile.
:: -----------------------------------------------------------------------------
:CompileAdv

CALL alan.exe %_COMPILE_OPTS_% %1  > nul 2>&1 ^
    && (
        SET /A _ADV_COM_=%_ADV_COM_% +1
        ECHO %_BG_GREEN_%
        ECHO -----------------------
        ECHO  COMPILATION SUCCEEDED 
        ECHO -----------------------
    ) || (
        SET /A _ERR_=%_ERR_% +1
        SET /A _ADV_ERR_=%_ADV_ERR_% +1
        ECHO %_BG_RED_%
        ECHO ~~~~~~~~~~~~~~~~~~~~~~~
        ECHO  COMPILATION FAILED^^!^^!^^! 
        ECHO ~~~~~~~~~~~~~~~~~~~~~~~
        ECHO %_RESET_COLORS_%%_BLUE_%
        ECHO Compiler report:%_RED_%
        :: Compile again in order to show compiler errors report
        CALL alan.exe %_COMPILE_OPTS_% %1
    )
ECHO %_RESET_COLORS_%%_GO_UP_%
EXIT /B
:: *****************************************************************************
:: *                                                                           *
:: *                        ADVENTURES TESTS FUNCTIONS                         *
:: *                                                                           *
:: *****************************************************************************

:: =============================================================================
:: func                          Print Test Title                               
:: =============================================================================
:: PARAMETERS:
:: %1 -- the adventure to test.
:: %2 -- the ".a3sol" commands-script to test the adventure with.
:: -----------------------------------------------------------------------------
:TestTitle

CALL :OperationTitle "TEST ^"%~1^" WITH ^"%_YELLOW_%%~2%_BLUE_%^""
EXIT /B
:: =============================================================================
:: func                 Execute Tests on Single Adventure                       
:: =============================================================================
:: PARAMETERS: none.
:: -----------------------------------------------------------------------------
:TestSingleAdv

:: Iterate Folders of Single Adventure -> Multiple Tests:
SET /A TMPC=1
:LoopTestSingleAdv
IF "!ADV_SINGLE[%TMPC%]DIR!" == "" GOTO :EndLoopTestSingleAdv
SET /A _ADV_EXE_=!_ADV_EXE_! +1
SET ADV_BIN=%_MAGENTA_%!ADV_SINGLE[%TMPC%]DIR!\%_YELLOW_%!ADV_SINGLE[%TMPC%]ADV!.a3c%_BLUE_%
PUSHD !ADV_SINGLE[%TMPC%]DIR!
FOR %%i IN (*.a3sol) DO (
    CALL :TestTitle "!ADV_BIN!" "%%i"
    CALL :ExecuteTest !ADV_SINGLE[%TMPC%]ADV! "%%i"
)
POPD
SET /A "TMPC+=1"
GOTO :LoopTestSingleAdv
:EndLoopTestSingleAdv
EXIT /B
:: =============================================================================
:: func                Execute Tests on Multiple Adventures                     
:: =============================================================================
: PARAMETRI: nessuno.
::
:: On every "<adventure>.a3c" file run the scripts matching "<adventure>*.a3sol".
:: -----------------------------------------------------------------------------
:TestMultiAdv

PUSHD %ADV_MULTIPLE_DIR%
FOR %%i IN (*.a3c) DO (
    SET /A _ADV_EXE_=!_ADV_EXE_! +1
    CALL :MultipleScripts "%%i"
)
POPD
EXIT /B
:: =============================================================================
:: func                      Execute Multiple Scripts                           
:: =============================================================================
:: PARAMETERS: the adventure to test.
:: -----------------------------------------------------------------------------
:MultipleScripts

FOR %%i IN (%~n1*.a3sol) DO (
    SET ADV_BIN=%_MAGENTA_%%ADV_MULTIPLE_DIR%\%_YELLOW_%%~n1.a3c%_BLUE_%
    CALL :TestTitle "!ADV_BIN!" "%%i"
    CALL :ExecuteTest %1 "%%i"
)
EXIT /B
:: =============================================================================
:: func                      Execute Commands-Script                            
:: =============================================================================
:: PARAMETERS:
:: %1 -- the adventure to test.
:: %2 -- the ".a3sol" commands-script to test the adventure with.
:: -----------------------------------------------------------------------------
:ExecuteTest

:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:: NOTE: The code doesn't check that the log was actually created on disk,
::       or that it's not a 0Kb file! Should improve this!
:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO %_RED_%
CALL arun.exe -r %1 < %2 > %~n2.a3log ^
    && (
    SET /A _TST_EXE_=!_TST_EXE_! +1
    ECHO %_BG_GREEN_%
    ECHO -----------------------------
    ECHO  TRANSCRIPT SAVED TO DISK^^!^^!^^! 
    ECHO -----------------------------
    ECHO %_RESET_COLORS_%%_WHITE_%
    ECHO Test transcript saved to "%_GREEN_%%~n2.a3log%_WHITE_%".
    ) || (
    SET /A _ERR_=%_ERR_% +1
    ECHO %_BG_RED_%
    ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ECHO  AN ERROR WAS ECOUNTERED!^^!^^!^^! 
    ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ECHO %_RESET_COLORS_%%_WHITE_%
    ECHO Something went wrong with the script "%_RED_%%~2%_WHITE_%".
    ECHO The transcription log might be incomplete or missing: "%_RED_%%~n2.a3log%_WHITE_%".
)
ECHO %_RESET_COLORS_%
EXIT /B
:: *****************************************************************************
:: *                                                                           *
:: *                           ANSI CODES FUNCTIONS                            *
:: *                                                                           *
:: *****************************************************************************

:: =============================================================================
:: func             Initialize ANSI Terminal Escapes Variables                  
:: =============================================================================
:: PARAMETERS: none.
:: -----------------------------------------------------------------------------
:DefineANSICodes

SET _RESET_COLORS_=[0m
SET _GO_UP_=[1A
SET _INVERS_=[7m
:: ========================
:: Foreground Colors
:: ========================
SET _WHITE_=[97m
SET _BLUE_=[36m
SET _CYAN_=[96m
SET _YELLOW_=[93m
SET _GRAY_=[37m
SET _MAGENTA_=[95m
SET _RED_=[91m
SET _GREEN_=[92m
:: ========================
:: Colored Backgrounds
:: ========================
SET _BG_GREEN_=[97;102m
SET _BG_RED_=[97;101m
EXIT /B
:: =============================================================================
:: func              Destroy ANSI Terminal Escapes Variables                    
:: =============================================================================
:: PARAMETERS: none.
::
:: Clean up env-vars before leaving script. This precaution is required because
:: of the code that ensures that CMD remains open if the script was launched via
:: File Explorer -- in that case, variables set by this script will persist.
:: -----------------------------------------------------------------------------
:DestroyANSICodes

SET _RESET_COLORS_=
SET _GO_UP_=
SET _INVERS_=
SET _WHITE_=
SET _BLUE_=
SET _CYAN_=
SET _YELLOW_=
SET _GRAY_=
SET _MAGENTA_=
SET _RED_=
SET _GREEN_=
SET _BG_GREEN_=
SET _BG_RED_=
EXIT /B
:: *****************************************************************************
:: *                                                                           *
:: *                        TEXT DECORATION FUNCTIONS                          *
:: *                                                                           *
:: *****************************************************************************
:: =============================================================================
:: func                        Print Header Banner                              
:: =============================================================================
:: PARAMETERS: none.
:: -----------------------------------------------------------------------------
:PrintBanner

ECHO %_GREEN_%
ECHO ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
ECHO ::                                                                            ::
ECHO ::%_YELLOW_%               ^
       ALAN STANDARD LIBRARY TEST SUITE                      %_GREEN_%::
ECHO ::                                                                            ::
ECHO ::%_YELLOW_%                      ^
       by Tristano Ajmone                             %_GREEN_%::
ECHO ::                                                                            ::
ECHO ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
ECHO %_WHITE_%
EXIT /B
:: =============================================================================
:: func                          Print Step Title                               
:: =============================================================================
:: PARAMETERS: the string for the title.
:: -----------------------------------------------------------------------------
:StepTitle

SET /A _STP_EXE_=!_STP_EXE_! +1
ECHO.
ECHO %_GREEN_%################################################################################%_YELLOW_%
ECHO STEP !_STP_EXE_!/%_STP_TOT_% ^| %~1
ECHO %_GREEN_%################################################################################%_WHITE_%
EXIT /B
:: =============================================================================
:: func                       Print Operation Title                             
:: =============================================================================
:: PARAMETERS: the string for the title.
::
:: Prints a frame with the counter of the current operation, the total number
:: of operations, and the title of the current operation.
:: -----------------------------------------------------------------------------
:OperationTitle

SET /A _CNT_EXE_=!_CNT_EXE_! +1
ECHO.
ECHO %_BLUE_%===============================================================================
ECHO !_CNT_EXE_!/%_CNT_TOT_% ^| %~1
ECHO ===============================================================================%_WHITE_%
EXIT /B
:: =============================================================================
::                            Stampa Cornice Errore                             
:: =============================================================================
:: PARAMETERS:nessuno.
:: -----------------------------------------------------------------------------
:ErrorFrame

ECHO.
ECHO %_RED_%////////////////////////////////////////////////////////////////////////////////
ECHO ///////////////////////////////// %_YELLOW_%FATAL ERROR%_RED_% //////////////////////////////////
ECHO ////////////////////////////////////////////////////////////////////////////////%_RESET_COLORS_%
EXIT /B
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                                The MIT License                             ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: MIT License
:: 
:: Copyright (c) 2018 Tristano Ajmone, https://github.com/tajmone
:: 
:: Permission is hereby granted, free of charge, to any person obtaining a copy
:: of this software and associated documentation files (the "Software"), to deal
:: in the Software without restriction, including without limitation the rights
:: to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
:: copies of the Software, and to permit persons to whom the Software is
:: furnished to do so, subject to the following conditions:
:: 
:: The above copyright notice and this permission notice shall be included in
:: all copies or substantial portions of the Software.
:: 
:: THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
:: IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
:: FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
:: AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
:: LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
:: OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
:: SOFTWARE.
::::::::::::::::::::::::::::::::::::{ EOF }:::::::::::::::::::::::::::::::::::::
