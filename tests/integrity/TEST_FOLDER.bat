:: "tests/integrity/TEST_FOLDER.bat"    v1.1.1 | 2020/11/04 | by Tristano Ajmone
:: -----------------------------------------------------------------------------
:: MULTIPLE ADVENTURES -- Run all tests in the folder.
:: -----------------------------------------------------------------------------
@ECHO OFF & CLS
:: Code Page 28591 = ISO 8859-1 Latin 1; Western European (ISO)
CHCP 28591 > nul

:: Delete old files:
DEL *.a3c   2> nul
DEL *.a3log 2> nul
DEL *.ifid  2> nul
DEL *.log   2> nul

FOR %%i IN (*.alan) DO (
  ECHO =====================================================
  ECHO COMPILE:   %%i
  CALL :CompileTest %%i
)

EXIT /B

:CompileTest
CALL alan.exe -import ..\..\StdLib\ %1  > nul 2>&1 ^
  && (
    FOR %%i IN (%~n1*.a3sol) DO CALL :ExecTest %~n1.a3c %%i
  ) || (
    ECHO ^*^* COMPILATION FAILED ^*^*
  )
EXIT /B

:ExecTest
ECHO TEST WITH: %2
CALL arun.exe -r %~n1.a3c < %2 > %~n2.a3log
EXIT /B
